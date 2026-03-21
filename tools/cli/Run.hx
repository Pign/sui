package tools.cli;

using StringTools;

/**
    Build and run the app.
    For macOS: launches the .app directly.
    For iOS/visionOS simulator: installs and launches in simulator.
    For iOS/visionOS device (--device): installs via devicectl and launches.
**/
class Run {
    public static function run(cwd:String, args:Array<String>) {
        var platform = if (args.length > 0 && !args[0].startsWith("-")) args[0] else "macos";
        var forDevice = false;
        var deviceName:String = null;
        for (arg in args) {
            if (arg == "--device") {
                forDevice = true;
            } else if (arg.startsWith("--device=")) {
                forDevice = true;
                deviceName = arg.substr(9);
            }
        }

        // Build first
        Build.run(cwd, args);

        var config = Build.readProjectConfig(cwd);
        var target = if (forDevice) '$platform device' else '$platform simulator';
        if (platform == "macos") target = "macos";
        Sys.println('Launching ${config.appName} on $target...');

        if (platform == "macos") {
            launchMacOS(cwd, config);
        } else if (forDevice) {
            launchDevice(cwd, config, platform, deviceName);
        } else {
            launchSimulator(cwd, config, platform);
        }
    }

    static function launchMacOS(cwd:String, config:Build.ProjectConfig) {
        var appPath = Build.findBuiltApp(cwd, config.appName, "macos");
        if (appPath != null) {
            Sys.command("open", [appPath]);
        } else {
            Sys.println("Error: Could not find built .app.");
            Sys.exit(1);
        }
    }

    static function launchSimulator(cwd:String, config:Build.ProjectConfig, platform:String) {
        var simName = switch (platform) {
            case "ios": "iPhone 16";
            case "visionos": "Apple Vision Pro";
            default: "iPhone 16";
        };

        Sys.command("xcrun", ["simctl", "boot", simName]);
        var appPath = Build.findBuiltApp(cwd, config.appName, platform);
        if (appPath != null) {
            Sys.command("xcrun", ["simctl", "terminate", "booted", config.bundleIdentifier]);
            Sys.command("xcrun", ["simctl", "install", "booted", appPath]);
            Sys.command("xcrun", ["simctl", "launch", "booted", config.bundleIdentifier]);
            Sys.command("open", ["-a", "Simulator"]);
        } else {
            Sys.println("Error: Could not find built app for $platform simulator.");
            Sys.exit(1);
        }
    }

    static function launchDevice(cwd:String, config:Build.ProjectConfig, platform:String, ?deviceName:String) {
        var appPath = Build.findBuiltApp(cwd, config.appName, platform, true);
        if (appPath == null) {
            Sys.println("Error: Could not find built app for $platform device.");
            Sys.exit(1);
            return;
        }

        var udid = Build.findConnectedDeviceUdid(deviceName);
        if (udid == null) {
            Sys.println("Error: No connected device found. Is it plugged in and unlocked?");
            Sys.println("Available devices:");
            Sys.command("xcrun", ["devicectl", "list", "devices"]);
            Sys.exit(1);
            return;
        }

        Sys.println('Installing on device ($udid)...');
        var installResult = Sys.command("xcrun", ["devicectl", "device", "install", "app", "--device", udid, appPath]);
        if (installResult != 0) {
            Sys.println("Error: Failed to install on device.");
            Sys.exit(1);
        }

        Sys.println("Launching on device...");
        Sys.command("xcrun", ["devicectl", "device", "process", "launch", "--device", udid, config.bundleIdentifier]);
    }

}
