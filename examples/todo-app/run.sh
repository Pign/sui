#!/bin/bash
set -e

PLATFORM="${1:-macos}"
APP_NAME="TodoList"
BUNDLE_ID="com.sui.todoapp"

echo "==> [1/4] Compiling Haxe (generates C++ & Swift)..."
haxe build.hxml

echo "==> [2/4] Assembling Xcode project..."
mkdir -p build/$PLATFORM/Sources
cp build/swift/*.swift build/$PLATFORM/Sources/

if [ ! -f build/$PLATFORM/Sources/HaxeRuntime.swift ]; then
cp ../../runtime/swift/*.swift build/$PLATFORM/Sources/
fi

cat > build/$PLATFORM/project.yml << YAML
name: $APP_NAME
options:
  bundleIdPrefix: com.sui
  deploymentTarget:
    macOS: "14.0"
  xcodeVersion: "15.0"
settings:
  SWIFT_VERSION: "5.9"
targets:
  $APP_NAME:
    type: application
    platform: macOS
    sources:
      - path: Sources
        type: group
    settings:
      PRODUCT_BUNDLE_IDENTIFIER: $BUNDLE_ID
      GENERATE_INFOPLIST_FILE: true
YAML

cd build/$PLATFORM
xcodegen generate 2>&1 | grep -v "^$"
cd ../..

echo "==> [3/4] Building with Xcode..."
cd build/$PLATFORM
xcodebuild build \
  -project $APP_NAME.xcodeproj \
  -scheme $APP_NAME \
  -configuration Debug \
  -derivedDataPath ./DerivedData \
  -quiet

echo "==> [4/4] Launching..."
open DerivedData/Build/Products/Debug/$APP_NAME.app
