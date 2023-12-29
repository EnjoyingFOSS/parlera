First, [get Flutter set up](https://docs.flutter.dev/get-started/install) on your computer and then download this repo.

Before building the app, open up the Terminal in the folder for the downloaded repo and run these commands:
1. `flutter pub get`
2. `flutter gen-l10n`

Then to build Parlera or to run it, run either `flutter build` or `flutter run` with your preferred arguments.

If the above guide doesn't work, you can try these steps:
1. Run `flutter clean`
2. If running on macOS, delete the "macos/Pods" folder and "macos/Podfile.lock" file. Same for iOS, except in the "ios" folder.