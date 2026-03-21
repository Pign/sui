#!/bin/bash
set -e

PLATFORM="${1:-ios}"
APP_NAME="SplitView"
BUNDLE_ID="com.sui.ipadsplit"
DEVICE="${2:-iPad Pro (11-inch) (4th generation)}"

echo "==> [1/4] Compiling Haxe (generates C++ & Swift)..."
haxe build.hxml

echo "==> [2/4] Assembling Xcode project..."
mkdir -p build/ios/Sources
cp build/swift/*.swift build/ios/Sources/

if [ ! -f build/ios/Sources/HaxeRuntime.swift ]; then
cat > build/ios/Sources/HaxeRuntime.swift << 'SWIFT'
import Foundation
public final class HaxeRuntime {
    public static func initialize() {}
}
SWIFT
cp ../../runtime/swift/HaxeBridge.swift build/ios/Sources/
cp ../../runtime/swift/ViewBridge.swift build/ios/Sources/
fi

cat > build/ios/project.yml << YAML
name: $APP_NAME
options:
  bundleIdPrefix: com.sui
  deploymentTarget:
    iOS: "17.0"
  xcodeVersion: "15.0"
settings:
  SWIFT_VERSION: "5.9"
targets:
  $APP_NAME:
    type: application
    platform: iOS
    sources:
      - path: Sources
        type: group
    settings:
      PRODUCT_BUNDLE_IDENTIFIER: $BUNDLE_ID
      GENERATE_INFOPLIST_FILE: true
YAML

cd build/ios
xcodegen generate 2>&1 | grep -v "^$"
cd ../..

echo "==> [3/4] Building with Xcode..."
cd build/ios
xcodebuild build \
  -project $APP_NAME.xcodeproj \
  -scheme $APP_NAME \
  -configuration Debug \
  -derivedDataPath ./DerivedData \
  -destination "platform=iOS Simulator,name=$DEVICE" \
  -quiet

echo "==> [4/4] Launching on $DEVICE..."
cd ../..
xcrun simctl boot "$DEVICE" 2>/dev/null || true
APP_PATH=$(find build/ios/DerivedData -name "$APP_NAME.app" -type d | head -1)
xcrun simctl install booted "$APP_PATH"
xcrun simctl launch booted $BUNDLE_ID
open -a Simulator
