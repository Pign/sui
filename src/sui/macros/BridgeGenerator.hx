package sui.macros;

using StringTools;

/**
    Generates the C++ ↔ Swift interop layer.
    Produces:
    - C++ header files exposing Haxe functions to Swift
    - Swift code that calls into C++ via Swift 5.9+ C++ interop
**/
class BridgeGenerator {
    /**
        Generate the C++ header that exposes Haxe functions to Swift.
    **/
    public static function generateCppHeader(functions:Array<BridgeFunction>):String {
        var buf = new StringBuf();
        buf.add("#ifndef HAXE_BRIDGE_H\n");
        buf.add("#define HAXE_BRIDGE_H\n\n");
        buf.add("#include <cstdint>\n\n");
        buf.add("#ifdef __cplusplus\n");
        buf.add('extern "C" {\n');
        buf.add("#endif\n\n");
        buf.add("// Initialize the hxcpp runtime. Must be called before any other bridge functions.\n");
        buf.add("void haxe_bridge_init(void);\n\n");
        buf.add("// Shutdown the hxcpp runtime.\n");
        buf.add("void haxe_bridge_shutdown(void);\n\n");

        for (fn in functions) {
            if (fn.doc != null)
                buf.add('// ${fn.doc}\n');
            buf.add('${cppReturnType(fn.returnType)} ${fn.cName}(${generateCppParams(fn.params)});\n\n');
        }

        buf.add("#ifdef __cplusplus\n");
        buf.add("}\n");
        buf.add("#endif\n\n");
        buf.add("#endif // HAXE_BRIDGE_H\n");
        return buf.toString();
    }

    /**
        Generate the C++ implementation that calls into Haxe via hxcpp.
    **/
    public static function generateCppImpl(functions:Array<BridgeFunction>):String {
        var buf = new StringBuf();
        buf.add('#include "HaxeBridge.h"\n');
        buf.add("#include <hxcpp.h>\n\n");
        buf.add("void haxe_bridge_init(void) {\n");
        buf.add("    hx::Boot();\n");
        buf.add("    __boot_all();\n");
        buf.add("}\n\n");
        buf.add("void haxe_bridge_shutdown(void) {\n");
        buf.add("    // hxcpp cleanup if needed\n");
        buf.add("}\n\n");

        for (fn in functions) {
            buf.add('${cppReturnType(fn.returnType)} ${fn.cName}(${generateCppParams(fn.params)}) {\n');
            buf.add('    // Call into Haxe: ${fn.haxeClass}.${fn.haxeMethod}\n');

            if (fn.returnType == "void") {
                buf.add('    // TODO: invoke Haxe method via hxcpp reflection\n');
            } else {
                buf.add('    // TODO: invoke Haxe method and return result\n');
                buf.add('    return ${cppDefaultValue(fn.returnType)};\n');
            }

            buf.add("}\n\n");
        }

        return buf.toString();
    }

    /**
        Generate a Swift module map for importing the C++ bridge.
    **/
    public static function generateModuleMap(headerPath:String):String {
        var buf = new StringBuf();
        buf.add('module HaxeBridgeC {\n');
        buf.add('    header "${headerPath}"\n');
        buf.add("    export *\n");
        buf.add("}\n");
        return buf.toString();
    }

    // --- Helpers ---

    static function generateCppParams(params:Array<BridgeParam>):String {
        if (params.length == 0) return "void";
        return [for (p in params) '${cppType(p.type)} ${p.name}'].join(", ");
    }

    static function cppType(haxeType:String):String {
        return switch (haxeType) {
            case "Int": "int32_t";
            case "Float": "double";
            case "Bool": "bool";
            case "String": "const char*";
            case "Void" | "void": "void";
            default: "void*";
        }
    }

    static function cppReturnType(haxeType:String):String {
        return cppType(haxeType);
    }

    static function cppDefaultValue(haxeType:String):String {
        return switch (haxeType) {
            case "Int": "0";
            case "Float": "0.0";
            case "Bool": "false";
            case "String": '""';
            default: "nullptr";
        }
    }
}

typedef BridgeFunction = {
    cName:String,
    haxeClass:String,
    haxeMethod:String,
    params:Array<BridgeParam>,
    returnType:String,
    ?doc:String
}

typedef BridgeParam = {
    name:String,
    type:String
}
