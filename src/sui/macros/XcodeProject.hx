package sui.macros;

using StringTools;

/**
    Generates xcodegen YAML configuration for building the Xcode project.
    Uses xcodegen (https://github.com/yonaskolb/XcodeGen) to produce .xcodeproj files.
**/
class XcodeProject {
    /**
        Generate the xcodegen project.yml for the given platform.
    **/
    public static function generateProjectYaml(config:XcodeProjectConfig):String {
        var buf = new StringBuf();
        buf.add('name: ${config.appName}\n');
        buf.add("options:\n");
        buf.add("  bundleIdPrefix: ${config.bundleIdPrefix}\n");
        buf.add("  deploymentTarget:\n");
        buf.add('    ${platformKey(config.platform)}: "${deploymentTarget(config.platform)}"\n');
        buf.add("  xcodeVersion: \"15.0\"\n");
        buf.add("settings:\n");
        buf.add("  SWIFT_VERSION: \"5.9\"\n");
        buf.add('  SWIFT_OBJC_INTEROP_MODE: "off"\n');
        buf.add("  CLANG_CXX_LANGUAGE_STANDARD: c++17\n");
        buf.add('  SWIFT_OBJC_BRIDGING_HEADER: ""\n');

        // Enable Swift/C++ interop
        buf.add("  OTHER_SWIFT_FLAGS:\n");
        buf.add('    - "-cxx-interoperability-mode=default"\n');
        buf.add("  HEADER_SEARCH_PATHS:\n");
        buf.add('    - "$(PROJECT_DIR)/bridge"\n');
        buf.add('    - "$(PROJECT_DIR)/cpp/include"\n');

        buf.add("\ntargets:\n");
        buf.add("  ${config.appName}:\n");
        buf.add('    type: application\n');
        buf.add('    platform: ${platformKey(config.platform)}\n');
        buf.add("    sources:\n");
        buf.add("      - path: Sources\n");
        buf.add("        type: group\n");
        buf.add("      - path: bridge\n");
        buf.add("        type: group\n");
        buf.add("    settings:\n");
        buf.add('      PRODUCT_BUNDLE_IDENTIFIER: ${config.bundleIdentifier}\n');
        buf.add('      INFOPLIST_FILE: Info.plist\n');
        buf.add('      CODE_SIGN_ENTITLEMENTS: Entitlements.plist\n');

        // Link hxcpp library
        buf.add("    dependencies: []\n");
        buf.add("    postBuildScripts: []\n");

        return buf.toString();
    }

    static function platformKey(platform:Platform):String {
        return switch (platform) {
            case MacOS: "macOS";
            case IOS: "iOS";
            case VisionOS: "visionOS";
        }
    }

    static function deploymentTarget(platform:Platform):String {
        return switch (platform) {
            case MacOS: "14.0";
            case IOS: "17.0";
            case VisionOS: "1.0";
        }
    }
}

typedef XcodeProjectConfig = {
    appName:String,
    bundleIdentifier:String,
    bundleIdPrefix:String,
    platform:Platform,
    ?teamId:String
}

enum Platform {
    MacOS;
    IOS;
    VisionOS;
}
