import sui.state.State;

/**
    Tests for the shared-memory bridge query API.
    Verifies null safety, bounds checking, value replacement,
    and registry lifetime.
**/
class TestSharedMemory {
    static var passed = 0;
    static var failed = 0;

    static function assert(condition:Bool, name:String) {
        if (condition) {
            passed++;
            Sys.println('  PASS: $name');
        } else {
            failed++;
            Sys.println('  FAIL: $name');
        }
    }

    static function main() {
        Sys.println("=== Shared Memory Bridge Tests ===\n");

        testNullStateName();
        testUnregisteredState();
        testEmptyArray();
        testOutOfBounds();
        testStringArrayElements();
        testIntArrayElements();
        testFloatArrayElements();
        testBoolArrayElements();
        testArrayReplacement();
        testNonArrayState();
        testObjectFieldAccess();
        testObjectFieldNullSafety();
        testRegistryOverwrite();
        testRegistryLifetime();

        Sys.println('\n=== Results: $passed passed, $failed failed ===');
        if (failed > 0) Sys.exit(1);
    }

    static function testNullStateName() {
        Sys.println("--- Null state name ---");
        assert(State._getArrayLength(null) == -1, "null name returns -1 length");
        assert(State._getArrayStringElement(null, 0) == "", "null name returns empty string element");
        assert(State._getArrayIntElement(null, 0) == 0, "null name returns 0 int element");
        assert(State._getArrayFloatElement(null, 0) == 0.0, "null name returns 0.0 float element");
        assert(State._getArrayBoolElement(null, 0) == false, "null name returns false bool element");
    }

    static function testUnregisteredState() {
        Sys.println("--- Unregistered state name ---");
        assert(State._getArrayLength("nonexistent") == -1, "unregistered name returns -1 length");
        assert(State._getArrayStringElement("nonexistent", 0) == "", "unregistered name returns empty string");
        assert(State._getArrayIntElement("nonexistent", 0) == 0, "unregistered name returns 0");
    }

    static function testEmptyArray() {
        Sys.println("--- Empty array ---");
        var s = new State<Array<String>>([], "emptyArr");
        assert(State._getArrayLength("emptyArr") == 0, "empty array has length 0");
        assert(State._getArrayStringElement("emptyArr", 0) == "", "empty array element returns empty string");
    }

    static function testOutOfBounds() {
        Sys.println("--- Out of bounds access ---");
        var s = new State<Array<Int>>([10, 20], "boundsTest");
        assert(State._getArrayLength("boundsTest") == 2, "array has length 2");
        assert(State._getArrayIntElement("boundsTest", -1) == 0, "negative index returns 0");
        assert(State._getArrayIntElement("boundsTest", 2) == 0, "index == length returns 0");
        assert(State._getArrayIntElement("boundsTest", 999) == 0, "large index returns 0");
    }

    static function testStringArrayElements() {
        Sys.println("--- String array elements ---");
        var s = new State<Array<String>>(["hello", "world", ""], "strArr");
        assert(State._getArrayLength("strArr") == 3, "string array has length 3");
        assert(State._getArrayStringElement("strArr", 0) == "hello", "first element is 'hello'");
        assert(State._getArrayStringElement("strArr", 1) == "world", "second element is 'world'");
        assert(State._getArrayStringElement("strArr", 2) == "", "third element is empty string");
    }

    static function testIntArrayElements() {
        Sys.println("--- Int array elements (no string conversion) ---");
        var s = new State<Array<Int>>([0, -1, 42, 2147483647], "intArr");
        assert(State._getArrayLength("intArr") == 4, "int array has length 4");
        assert(State._getArrayIntElement("intArr", 0) == 0, "zero element");
        assert(State._getArrayIntElement("intArr", 1) == -1, "negative element");
        assert(State._getArrayIntElement("intArr", 2) == 42, "positive element");
        assert(State._getArrayIntElement("intArr", 3) == 2147483647, "max int element");
    }

    static function testFloatArrayElements() {
        Sys.println("--- Float array elements (no string conversion) ---");
        var s = new State<Array<Float>>([0.0, 3.14, -1.5], "floatArr");
        assert(State._getArrayLength("floatArr") == 3, "float array has length 3");
        assert(State._getArrayFloatElement("floatArr", 0) == 0.0, "zero element");
        assert(Math.abs(State._getArrayFloatElement("floatArr", 1) - 3.14) < 0.001, "pi element");
        assert(State._getArrayFloatElement("floatArr", 2) == -1.5, "negative element");
    }

    static function testBoolArrayElements() {
        Sys.println("--- Bool array elements (no string conversion) ---");
        var s = new State<Array<Bool>>([true, false, true], "boolArr");
        assert(State._getArrayLength("boolArr") == 3, "bool array has length 3");
        assert(State._getArrayBoolElement("boolArr", 0) == true, "true element");
        assert(State._getArrayBoolElement("boolArr", 1) == false, "false element");
        assert(State._getArrayBoolElement("boolArr", 2) == true, "true element again");
    }

    static function testArrayReplacement() {
        Sys.println("--- Array value replacement (shared memory sees new data) ---");
        var s = new State<Array<String>>(["old"], "replaceTest");
        assert(State._getArrayLength("replaceTest") == 1, "initial length is 1");
        assert(State._getArrayStringElement("replaceTest", 0) == "old", "initial value is 'old'");

        // Replace the array — shared memory should see the new one
        s.value = ["new", "data", "here"];
        assert(State._getArrayLength("replaceTest") == 3, "replaced length is 3");
        assert(State._getArrayStringElement("replaceTest", 0) == "new", "replaced first element");
        assert(State._getArrayStringElement("replaceTest", 2) == "here", "replaced third element");

        // Replace with empty
        s.value = [];
        assert(State._getArrayLength("replaceTest") == 0, "empty after replacement");
    }

    static function testNonArrayState() {
        Sys.println("--- Non-array state queried as array ---");
        var s = new State<String>("hello", "strState");
        assert(State._getArrayLength("strState") == -1, "string state returns -1 length");
        assert(State._getArrayStringElement("strState", 0) == "", "string state returns empty element");

        var s2 = new State<Int>(42, "intState");
        assert(State._getArrayLength("intState") == -1, "int state returns -1 length");
    }

    static function testObjectFieldAccess() {
        Sys.println("--- Object field access ---");
        var items:Array<Dynamic> = [
            {name: "Alice", age: 30, score: 9.5, active: true},
            {name: "Bob", age: 25, score: 7.2, active: false},
        ];
        var s = new State<Array<Dynamic>>(items, "objects");
        assert(State._getArrayLength("objects") == 2, "object array has length 2");
        assert(State._getObjectField("objects", 0, "name") == "Alice", "first name is Alice");
        assert(State._getObjectField("objects", 1, "name") == "Bob", "second name is Bob");
        assert(State._getObjectIntField("objects", 0, "age") == 30, "Alice age is 30");
        assert(State._getObjectIntField("objects", 1, "age") == 25, "Bob age is 25");
        assert(Math.abs(State._getObjectFloatField("objects", 0, "score") - 9.5) < 0.001, "Alice score is 9.5");
        assert(State._getObjectBoolField("objects", 0, "active") == true, "Alice is active");
        assert(State._getObjectBoolField("objects", 1, "active") == false, "Bob is not active");
    }

    static function testObjectFieldNullSafety() {
        Sys.println("--- Object field null safety ---");
        var items:Array<Dynamic> = [{name: "test"}];
        var s = new State<Array<Dynamic>>(items, "objNull");

        // Missing field
        assert(State._getObjectField("objNull", 0, "missing") == "", "missing field returns empty string");
        assert(State._getObjectIntField("objNull", 0, "missing") == 0, "missing int field returns 0");
        assert(State._getObjectFloatField("objNull", 0, "missing") == 0.0, "missing float field returns 0.0");
        assert(State._getObjectBoolField("objNull", 0, "missing") == false, "missing bool field returns false");

        // Out of bounds index
        assert(State._getObjectField("objNull", 5, "name") == "", "out of bounds returns empty");

        // Null field name
        assert(State._getObjectField("objNull", 0, null) == "", "null field name returns empty");

        // Null state name
        assert(State._getObjectField(null, 0, "name") == "", "null state name returns empty");
    }

    static function testRegistryOverwrite() {
        Sys.println("--- Registry overwrite (same name, new State) ---");
        var s1 = new State<Array<String>>(["first"], "overwrite");
        assert(State._getArrayStringElement("overwrite", 0) == "first", "original value");

        // Create new State with same name — should replace in registry
        var s2 = new State<Array<String>>(["second"], "overwrite");
        assert(State._getArrayStringElement("overwrite", 0) == "second", "overwritten value");

        // Original State still works locally
        assert(s1.value[0] == "first", "original State instance unchanged");
    }

    static function testRegistryLifetime() {
        Sys.println("--- Registry keeps state alive ---");
        // Create state in a local scope
        createTemporaryState();

        // State should still be queryable via registry (strong reference)
        assert(State._getArrayLength("lifetime") == 2, "state survives scope exit");
        assert(State._getArrayStringElement("lifetime", 0) == "still", "value survives scope exit");
    }

    static function createTemporaryState() {
        var s = new State<Array<String>>(["still", "alive"], "lifetime");
    }
}
