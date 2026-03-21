#!/bin/bash
set -e

PLATFORM="${1:-macos}"
APP_NAME="NormalHaxe"
BUNDLE_ID="com.haxeapple.normalhaxe"
HXCPP_DIR="/usr/local/lib/haxe/lib/hxcpp/4,3,2"

echo "==> [1/5] Compiling Haxe (generates C++ & Swift)..."
haxe build.hxml

echo "==> [2/5] Building hxcpp static library..."
mkdir -p build/lib
find build/cpp/obj -name "*.o" ! -name "*__main__*" | xargs ar rcs build/lib/libhaxe.a

echo "==> [3/5] Compiling C++ bridge..."
clang++ -c \
  -std=c++17 \
  -I"$HXCPP_DIR/include" \
  -I"build/cpp/include" \
  -DHX_MACOS \
  -DHXCPP_ARM64 \
  -DHXCPP_M64 \
  -DHXCPP_VISIT_ALLOCS \
  -DHX_SMART_STRINGS \
  -DHXCPP_API_LEVEL=430 \
  -arch arm64 \
  build/swift/HaxeBridgeC.cpp \
  -o build/lib/HaxeBridgeC.o

ar rcs build/lib/libhaxe.a build/lib/HaxeBridgeC.o

echo "==> [4/5] Assembling Xcode project..."
mkdir -p build/$PLATFORM/Sources
mkdir -p build/$PLATFORM/lib

# Copy all generated Swift files
for f in build/swift/*.swift; do
  cp "$f" build/$PLATFORM/Sources/
done
cp build/swift/HaxeBridgeC.h build/$PLATFORM/Sources/
cp build/lib/libhaxe.a build/$PLATFORM/lib/

# Copy runtime
cp ../../runtime/swift/HaxeRuntime.swift build/$PLATFORM/Sources/
cp ../../runtime/swift/HaxeBridge.swift build/$PLATFORM/Sources/
cp ../../runtime/swift/ViewBridge.swift build/$PLATFORM/Sources/

cat > build/$PLATFORM/project.yml << YAML
name: $APP_NAME
options:
  bundleIdPrefix: com.haxeapple
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
      SWIFT_OBJC_BRIDGING_HEADER: Sources/HaxeBridgeC.h
      LIBRARY_SEARCH_PATHS:
        - "\$(PROJECT_DIR)/lib"
      OTHER_LDFLAGS:
        - "-lhaxe"
        - "-lc++"
YAML

cd build/$PLATFORM
xcodegen generate 2>&1 | grep -v "^$"
cd ../..

echo "==> [5/5] Building with Xcode..."
cd build/$PLATFORM
xcodebuild build \
  -project $APP_NAME.xcodeproj \
  -scheme $APP_NAME \
  -configuration Debug \
  -derivedDataPath ./DerivedData \
  -quiet

echo "==> Done! Launching..."
open DerivedData/Build/Products/Debug/$APP_NAME.app
