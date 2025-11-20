CodeMagic CI – Quick setup instructions

1) Create a CodeMagic account and connect your repository (GitHub/GitLab/Bitbucket).

2) In the project settings -> Environment variables, add the following secure variables:
   - `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` : the JSON content of your Google Play service account (for Play upload).
   - `APP_STORE_CONNECT_API_KEY_FILE` : upload your App Store Connect .p8 key file (set the path here).
   - `APP_STORE_CONNECT_KEY_ID` : your App Store Connect API Key ID.
   - `APP_STORE_CONNECT_ISSUER_ID` : your App Store Connect Issuer ID.

3) Code signing for iOS:
   - In CodeMagic, configure code signing: upload provisioning profiles and certificates or enable Automatic signing using your Apple account.
   - Make sure the bundle identifier matches the app in App Store Connect.

4) Trigger the workflow `ios-and-android-release` from the CodeMagic UI or via push.

5) After a successful build, CodeMagic will upload:
   - Android AAB to Google Play Internal track.
   - iOS IPA to App Store Connect (TestFlight) and notify testers (if enabled).

Notes:
- Keep secrets private. Do NOT commit keys to the repository.
- For Play uploads you need a play service account with rights to edit releases.
- For App Store Connect upload you need an API Key (App Store Connect -> Users and Access -> Keys -> generate).


