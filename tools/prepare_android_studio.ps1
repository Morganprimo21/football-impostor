<#
  Prepare Android Studio project
  Run this from the project root in PowerShell:
    .\tools\prepare_android_studio.ps1
  The script will:
    - check that `flutter` is available
    - run `flutter create .` to generate android/ ios/ windows/ linux folders if missing
    - run `flutter pub get`
    - print next steps to open in Android Studio
#>
try {
  Write-Host "Checking flutter availability..."
  $null = & flutter --version 2>$null
} catch {
  Write-Error "Flutter is not available in PATH. Please add Flutter to PATH or run this script from a terminal where flutter is available."
  exit 1
}

Write-Host "Running 'flutter create .' (will not overwrite lib/ or existing files)..."
& flutter create . | Write-Host

Write-Host "Running 'flutter pub get'..."
& flutter pub get | Write-Host

Write-Host ""
Write-Host "Preparation complete."
Write-Host "Next steps to open in Android Studio:"
Write-Host "  1) Open Android Studio -> Open an existing project -> select this folder."
Write-Host "  2) Let Gradle sync/download dependencies."
Write-Host "  3) From the device chooser, run on an Android emulator or connected device."
Write-Host ""
Write-Host "If you plan to test on Android, install Android Studio's SDK and create an AVD first."
exit 0

