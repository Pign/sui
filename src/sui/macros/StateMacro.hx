package sui.macros;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;

/**
    Build macro for App subclasses that transforms @:state fields.

    Converts:
    ```haxe
    @:state var count:Int = 0;
    ```

    Into:
    ```haxe
    var count:State<Int>;
    // constructor init: count = new State<Int>(0, "count");
    ```
**/
class StateMacro {
    public static function build():Array<Field> {
        var fields = Context.getBuildFields();
        var stateInits:Array<Expr> = [];
        var newFields:Array<Field> = [];

        for (field in fields) {
            var isState = false;
            if (field.meta != null) {
                for (m in field.meta) {
                    if (m.name == ":state") {
                        isState = true;
                        break;
                    }
                }
            }

            if (!isState) {
                newFields.push(field);
                continue;
            }

            // Extract the original type and default value
            var origType = field.kind.match(FVar(t, _)) ? field.kind.getParameters()[0] : null;
            var defaultExpr = field.kind.match(FVar(_, e)) ? field.kind.getParameters()[1] : null;

            if (origType == null) {
                Context.error("@:state fields must have an explicit type", field.pos);
                continue;
            }

            // Default value fallback
            if (defaultExpr == null) {
                defaultExpr = macro null;
            }

            var fieldName = field.name;

            // Replace field type: T → State<T>
            var stateType:ComplexType = TPath({
                pack: ["sui", "state"],
                name: "State",
                params: [TPType(origType)]
            });

            // Rewrite the field as State<T> with no initializer (set in constructor)
            newFields.push({
                name: field.name,
                access: field.access,
                kind: FVar(stateType, null),
                pos: field.pos,
                meta: field.meta,
                doc: field.doc,
            });

            // Generate constructor init: fieldName = new State<T>(defaultValue, "fieldName")
            var nameExpr = macro $v{fieldName};
            stateInits.push(macro $i{fieldName} = new sui.state.State($defaultExpr, $nameExpr));
        }

        if (stateInits.length > 0) {
            // Find or create constructor
            var ctorFound = false;
            for (f in newFields) {
                if (f.name == "new") {
                    ctorFound = true;
                    switch (f.kind) {
                        case FFun(func):
                            // Prepend state inits before existing constructor body
                            var existingBody = func.expr;
                            var allExprs:Array<Expr> = stateInits.copy();
                            if (existingBody != null) allExprs.push(existingBody);
                            func.expr = macro $b{allExprs};
                        default:
                    }
                    break;
                }
            }

            if (!ctorFound) {
                // Create a constructor that calls super() and inits state
                var allExprs:Array<Expr> = [macro super()];
                for (e in stateInits) allExprs.push(e);
                newFields.push({
                    name: "new",
                    access: [APublic],
                    kind: FFun({
                        args: [],
                        ret: null,
                        expr: macro $b{allExprs},
                    }),
                    pos: Context.currentPos(),
                });
            }
        }

        return newFields;
    }
}
#end
