![alt text](https://signal.org/assets/header/logo-f7ef605fe417d5520d38d546b3b774b4261c75220b9904da4d8b2ffc19a761ff.png)

# The Official Signal Desktop Builder For Mobian

## signal-desktop_5.31.1_arm64/unstable

This project builds Signal Desktop for Mobian/unstable on Arm64, currently targeting release `5.31.x`.

This is the signed release: `builds/release/signal-desktop_5.xx.x_arm64.deb`.

Signature: `builds/release/signal-desktop_5.xx.x_arm64.deb.sig`.

Public Key: `0558260a88ff08f8dddf791fe73b9457917830506be3d8dbc1311e8d769c5ac777`

## Usage:

1. Build with docker: `sudo ./buildscript.sh`, it takes about 3 hours.
2. Switch your device to `Mobian/unstable` if you haven't already.
2. Copy the `.deb` to your device and `sudo apt install ./signal-desktop_5.xx.x_arm64.deb`.

## Current Status:

* [x] Signal Desktop builds
* [x] libsignal-client builds
* [x] better-sqlite3 builds
* [x] ringrtc builds
* [x] Bundle all builds and outputs
* [x] Sign `.deb` with keypair

## Successful Builds:

... (many builds before and many to come)

* [x] 5.28.0
* [x] 5.29.0
* [x] 5.30.0
* [x] 5.31.1

## See also:

* Included buildscript-demo.cast, it's an asciinema demo file.
* https://wiki.mobian-project.org/doku.php?id=signaldesktop
* https://gitlab.com/ohfp/pinebookpro-things/-/blob/master/signal-desktop/PKGBUILD
