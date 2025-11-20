Football Impostor — Pass & Play

Placeholders and next steps:
- Add your AdMob IDs in `lib/monetization/ads_service.dart`.
- Add your IAP product id for `remove_ads` in `lib/monetization/purchase_service.dart`.
- Assets placeholders are present under `assets/` as `hector_*.png`.

How to run:
1. flutter pub get
2. flutter run

Notes:
- The game is offline and pass & play only. After the home screen, no text inputs are shown.
- Double tap is enforced on secret screens to advance.
Open in Android Studio

1. Ensure Flutter is on your PATH and Android SDK + Android Studio are installed.
2. From the project root run the helper script (PowerShell):

```powershell
.\tools\prepare_android_studio.ps1
```

This runs `flutter create .` (generates platform folders if missing) and `flutter pub get`.

3. Open Android Studio → Open an existing project → select this project's folder.
4. Wait for Gradle sync / SDK downloads. Create an AVD in AVD Manager if needed.
5. Select a device and Run the app.

Notes:
- If Android Studio reports missing SDK, open SDK Manager and install Platform Tools, an SDK Platform and an emulator image.
- For debugging on a device, enable Developer Options and USB debugging on your Android phone.

AdMob & Ads setup (quick)
- Android:
  - Add your App ID in `android/app/src/main/AndroidManifest.xml` as:

    ```xml
    <meta-data android:name="com.google.android.gms.ads.APPLICATION_ID"
               android:value="ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX"/>
    ```

  - The project currently contains the AdMob test App ID. Replace with your real one before publishing.

- iOS:
  - Add your App ID in `ios/Runner/Info.plist`:

    ```xml
    <key>GADApplicationIdentifier</key>
    <string>ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX</string>
    ```

- In demo build the project uses placeholders instead of live ads. To re-enable ads:
  - Re-add real ad unit IDs in `lib/monetization/ads_service.dart`.
  - Re-insert App ID metadata in Android/iOS manifests.
  - Remove demo placeholders and test-device overrides.

- Testing:
  - Use test ad unit IDs while developing to avoid policy violations.
  - Mark your device as a test device in AdMob or via `RequestConfiguration.testDeviceIds`.
  - Verify `onAdLoaded` callbacks in logs and handle `onAdFailedToLoad`.

Privacy & legal:
- If you target EU users, implement consent collection for personalized ads (GDPR). Consult AdMob documentation.
