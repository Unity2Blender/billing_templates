#!/bin/bash

# Flutter Android App Launch Script
# This script lists active devices and runs the app on Android emulator/device

echo "🤖 Starting Flutter Android App..."

# Ensure dependencies are up to date
echo "📦 Getting Flutter dependencies..."
flutter pub get

echo ""
echo "📱 Checking for connected Android devices..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# List Flutter devices
echo "🔍 Flutter Devices:"
flutter devices

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Count available Android devices/emulators
DEVICE_COUNT=$(flutter devices | grep -c "mobile")

if [ "$DEVICE_COUNT" -eq 0 ]; then
    echo "❌ No Android devices or emulators found!"
    echo ""
    echo "💡 To start an emulator, run:"
    echo "   emulator -avd <emulator_name>"
    echo ""
    echo "💡 Or list available emulators:"
    echo "   emulator -list-avds"
    echo ""
    echo "💡 Or connect a physical device via USB with debugging enabled"
    exit 1
fi

echo "✅ Found $DEVICE_COUNT Android device(s)"
echo ""

# Get the first Android device ID
# Extract the device ID which appears after the first bullet (•) and before the second bullet
ANDROID_DEVICE=$(flutter devices | grep "mobile" | head -n 1 | sed -E 's/.*• ([^ ]+) •.*/\1/')

if [ -z "$ANDROID_DEVICE" ]; then
    echo "⚠️  Could not auto-detect device ID. Launching on default Android device..."
    echo "🚀 Launching app on Android..."
    flutter run
else
    echo "🚀 Launching app on device: $ANDROID_DEVICE"
    flutter run -d "$ANDROID_DEVICE"
fi

# Alternative commands (commented out):
# For release build:
# flutter run --release

# For specific device (replace with actual device ID):
# flutter run -d emulator-5554

# For hot reload enabled (default with flutter run):
# flutter run --hot

# To install APK only:
# flutter install

# To build APK:
# flutter build apk --debug
# flutter build apk --release
