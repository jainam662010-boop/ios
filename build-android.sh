#!/bin/bash

echo "=========================================="
echo "  Class 10Edu - Play Store Build Script"
echo "=========================================="
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "ERROR: Node.js is not installed!"
    echo "Please install Node.js 18 or higher from https://nodejs.org/"
    exit 1
fi

echo "[1/5] Installing dependencies..."
npm install
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to install dependencies!"
    exit 1
fi

echo "[2/5] Syncing Capacitor with Android..."
npx cap sync android
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to sync Capacitor!"
    exit 1
fi

echo "[3/5] Checking for signing keystore..."
if [ ! -f "android/app/keystore.jks" ]; then
    echo "Creating new signing keystore..."
    echo ""
    echo "IMPORTANT: Remember this password!"
    echo "Default: class10edu2024"
    echo ""
    keytool -genkey -v -keystore android/app/keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias class10edu -storepass class10edu2024 -keypass class10edu2024 -dname "CN=Class10Edu, OU=Education, O=Class10Edu, L=Delhi, ST=Delhi, C=IN"
    if [ $? -ne 0 ]; then
        echo "ERROR: Failed to create keystore!"
        exit 1
    fi
fi

echo "[4/5] Building Release AAB (App Bundle)..."
cd android
./gradlew bundleRelease
if [ $? -ne 0 ]; then
    echo "ERROR: Build failed!"
    cd ..
    exit 1
fi
cd ..

echo "[5/5] Build completed successfully!"
echo ""
echo "=========================================="
echo "  BUILD SUCCESSFUL!"
echo "=========================================="
echo ""
echo "Your AAB file is ready at:"
echo "android/app/build/outputs/bundle/release/app-release.aab"
echo ""
echo "Next steps:"
echo "1. Go to https://play.google.com/console"
echo "2. Create new app or select existing"
echo "3. Upload the AAB file"
echo "4. Complete store listing"
echo "5. Publish!"
echo ""
