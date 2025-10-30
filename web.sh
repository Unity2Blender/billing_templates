#!/bin/bash

# Flutter Web App Launch Script
# This script ensures smooth launch of the Flutter web app in Chrome browser (debug mode)

echo "🚀 Starting Flutter Web App..."

# Ensure dependencies are up to date
echo "📦 Getting Flutter dependencies..."
flutter pub get

# Launch the app in Chrome browser in debug mode
echo "🌐 Launching app in Chrome (debug mode)..."
flutter run -d chrome

# Alternative commands (commented out):
# For production build and serve:
# flutter build web && cd build/web && python3 -m http.server 8000

# For specific Chrome instance:
# flutter run -d chrome --web-renderer html

# For hot reload enabled (default with flutter run):
# flutter run -d chrome --web-port=8080
