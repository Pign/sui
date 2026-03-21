package tools.cli;

import sys.io.File;
import sys.FileSystem;

/**
    Scaffolds a new sui project.
    Creates directory structure, build.hxml, and a minimal App class.
**/
class Init {
    public static function run(cwd:String, args:Array<String>) {
        var projectName = if (args.length > 0) args[0] else "MyHaxeApp";
        var projectDir = '$cwd/$projectName';

        if (FileSystem.exists(projectDir)) {
            Sys.println('Error: Directory "$projectName" already exists.');
            Sys.exit(1);
        }

        Sys.println('Creating new sui project: $projectName');

        // Create directory structure
        FileSystem.createDirectory(projectDir);
        FileSystem.createDirectory('$projectDir/src');
        FileSystem.createDirectory('$projectDir/swift');

        // Create sui.json
        // Try auto-detecting team ID for device builds
        var teamIdLine = "";
        try {
            var proc = new sys.io.Process("security", ["find-certificate", "-c", "Apple Development", "-p"]);
            var pem = proc.stdout.readAll().toString();
            proc.close();
            if (pem.length > 0) {
                var proc2 = new sys.io.Process("openssl", ["x509", "-noout", "-subject"]);
                proc2.stdin.writeString(pem);
                proc2.stdin.close();
                var subject = proc2.stdout.readAll().toString();
                proc2.close();
                var ouIdx = subject.indexOf("OU = ");
                if (ouIdx != -1) {
                    var ouEnd = subject.indexOf(",", ouIdx);
                    if (ouEnd == -1) ouEnd = subject.length;
                    var teamId = StringTools.trim(subject.substring(ouIdx + 5, ouEnd));
                    teamIdLine = ',\n    "teamId": "$teamId"';
                    Sys.println('Detected signing team: $teamId');
                }
            }
        } catch (e:Dynamic) {}

        File.saveContent('$projectDir/sui.json', '{
    "appName": "$projectName",
    "bundleIdentifier": "com.example.${projectName.toLowerCase()}",
    "bundleIdPrefix": "com.example"$teamIdLine
}
');

        // Create build.hxml
        File.saveContent('$projectDir/build.hxml', '-cp src
-lib sui
-lib hxcpp
--macro sui.macros.SwiftGenerator.register()
-main $projectName
-cpp build/cpp
');

        // Create main app file
        File.saveContent('$projectDir/src/$projectName.hx', 'import sui.App;
import sui.View;
import sui.ui.*;

class $projectName extends App {
    static function main() {}

    public function new() {
        super();
        appName = "$projectName";
        bundleIdentifier = "com.example.${projectName.toLowerCase()}";
    }

    override function body():View {
        return new VStack([
            new Text("Hello from Haxe!")
                .font(FontStyle.LargeTitle)
                .padding(),
            new Text("Built with sui")
                .foregroundColor(ColorValue.Secondary)
        ]);
    }
}
');

        // Create .gitignore
        File.saveContent('$projectDir/.gitignore', 'build/
*.xcodeproj
*.xcworkspace
DerivedData/
');

        Sys.println('Project "$projectName" created successfully!');
        Sys.println("");
        Sys.println("Next steps:");
        Sys.println('  cd $projectName');
        Sys.println("  sui build macos");
        Sys.println("  sui run macos");
    }
}
