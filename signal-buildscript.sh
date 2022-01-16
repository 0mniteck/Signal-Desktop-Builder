#!/bin/bash
source $HOME/.cargo/env
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Build libsignal-client
echo "Entering /libsignal-client"
pushd /libsignal-client/node/
rustup toolchain install nightly-2021-09-16
rustup default nightly-2021-09-16
nvm use 16.9.1
yarn install
yarn tsc
mkdir -p /signal-client/prebuilds/linux-arm64
cp build/Release/libsignal_client_linux_arm64.node /signal-client/prebuilds/linux-arm64/node.napi.node
popd

# Build better-sqlite3
echo "Entering /better-sqlite3"
pushd /better-sqlite3
# Apply patch to use local (dynamic) libraries
patch -Np1 -i ../better-sqlite3.patch
rm -f Relase/obj/gen/sqlite3/OpenSSL-Linux/libcrypto.a
nvm use 16.9.1
npm install tar
npm run build-release
yarn install
popd

# Build Signal-Desktop
echo "Entering /Signal-Desktop"
pushd /Signal-Desktop
git-lfs install
sed -r 's#("@signalapp/signal-client": ").*"#\1file:../signal-client"#' -i package.json
sed -r 's#("better-sqlite3": ").*"#\1file:../better-sqlite3"#' -i package.json
sed -r 's#("ringrtc": ").*"#\1file:../signal-ringrtc-node"#' -i package.json
nvm use 16.9.1
yarn install && yarn install --frozen-lockfile
yarn build:dev && yarn build:release --arm64 --linux deb && debpath=$(ls /Signal-Desktop/release/signal-desktop_*)
if [ ! -f /Signal-Desktop/release/private.key ]; then
  echo "Generating New Keypair."
  yarn node ts/updater/generateKeyPair.js --key /Signal-Desktop/release/public.key --private /Signal-Desktop/release/private.key
  echo "Signing Release."
  yarn sign-release --private /Signal-Desktop/release/private.key --update $debpath
else
  echo "Signing Release."
  yarn sign-release --private /Signal-Desktop/release/private.key --update $debpath
fi
sha512sum release/*.deb && sha512sum release/*.deb > release/release.sha512sum
echo "Public Key: "$(cat /Signal-Desktop/release/public.key) && echo "Public Key: "$(cat /Signal-Desktop/release/public.key) >> release/release.sha512sum
echo "Build Complete on "$(date -u) && echo "Build Complete on "$(date -u) >> release/release.sha512sum
ls -la release/
popd
