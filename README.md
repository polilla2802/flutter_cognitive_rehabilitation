# Commands: Build Project

Build Android on Production

> flutter build appbundle --flavor prod

Build iOS on Production

> You should build using xcode (prod scheme + release-prod target + all device targets)

Build Android on Development

> flutter build appbundle --flavor dev

Build iOS on Development

> You should build using xcode (dev scheme + release-dev target + all device targets)

# Commands: Run Project

Run Local on Production

> (First Method): Run vscode debugger ("Cognitive Prod" runnable)

> (Second Method): flutter run -t lib/main.dart --flavor prod

Run Local on Development

> (First Method): Run vscode debugger ("Cognitive Dev" runnable)

> (Second Method): flutter run -t lib/main_dev.dart --flavor dev

Run Release (as Local) on Development

> flutter run --release --flavor dev --target lib/main_dev.dart

# Command to obtain productive SHA1 and SHA256

(you should change _/Users/darklord/Docs/keys/key.jks_ with the path location of your key.jks)

> keytool -list -v \ -alias key -keystore /Users/darklord/Docs/keys/key.jks
> password: [the key password]

# Command to obtain debug SHA1 and SHA256

> keytool -list -v \ -alias androiddebugkey -keystore ~/.android/debug.keystore
> password: android