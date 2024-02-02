First, [get Flutter set up](https://docs.flutter.dev/get-started/install) on your computer and then download this repo.

Check the platform requirements below to see if there are extra steps for your platform.

Before building the app, open up the Terminal in the folder for the downloaded repo and run these commands:
1. `flutter pub get`
2. `flutter gen-l10n`

Then to build Parlera or to run it, run either `flutter build` or `flutter run` with your preferred arguments.

If rebuilding is failing, run `flutter clean` and build again.

# Platform requirements

## Linux
Install these dependencies before building:
- For the [audioplayers](https://github.com/bluefireteam/audioplayers/blob/main/packages/audioplayers_linux/README.md#setup-for-linux) package:
    - sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev
    - sudo apt-get install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev

## macOS and iOS

No need to install anything.

However, if rebuilding is failing, try to delete the "macos/Pods" folder and "macos/Podfile.lock" file, then rebuild. Same for iOS, except in the "ios" folder.