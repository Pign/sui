/**
 * C bridge for ViewNode tree traversal.
 * Called by native dynamic renderers (SwiftUI, Compose, WinUI)
 * to walk the Haxe view tree at runtime.
 *
 * Each function calls into Haxe via hxcpp reflection.
 */

#include <hxcpp.h>

// Forward declare the Haxe ViewNodeBridge class
// These will be resolved at link time from the hxcpp static library.

extern "C" {

// --- View tree lifecycle ---

// Rebuild the view tree (call App.body())
void viewnode_rebuild(void) {
    hx::SetTopOfStack(nullptr, true);
    try {
        ::Type_obj::callStatic(
            ::Type_obj::resolveClass(HX_CSTRING("sui.runtime.ViewNodeBridge")),
            HX_CSTRING("rebuild"),
            ::cpp::ObjectArray<Dynamic>(0, 0)
        );
    } catch (...) {}
    hx::SetTopOfStack(nullptr, false);
}

// --- Node accessors (node passed as opaque hxcpp Dynamic) ---

// Get view type string. Caller must copy the result.
const char* viewnode_get_type(void* node) {
    hx::SetTopOfStack(nullptr, true);
    const char* result = "";
    try {
        Dynamic hxNode = (hx::Object*)node;
        auto args = ::cpp::ObjectArray<Dynamic>(1, 1);
        args[0] = hxNode;
        Dynamic ret = ::Type_obj::callStatic(
            ::Type_obj::resolveClass(HX_CSTRING("sui.runtime.ViewNodeBridge")),
            HX_CSTRING("getViewType"),
            args
        );
        if (ret != null()) result = ret.val_cast<String>().__CStr();
    } catch (...) {}
    hx::SetTopOfStack(nullptr, false);
    return result;
}

// Get number of children
int32_t viewnode_child_count(void* node) {
    hx::SetTopOfStack(nullptr, true);
    int32_t result = 0;
    try {
        Dynamic hxNode = (hx::Object*)node;
        auto args = ::cpp::ObjectArray<Dynamic>(1, 1);
        args[0] = hxNode;
        Dynamic ret = ::Type_obj::callStatic(
            ::Type_obj::resolveClass(HX_CSTRING("sui.runtime.ViewNodeBridge")),
            HX_CSTRING("getChildCount"),
            args
        );
        result = (int)ret;
    } catch (...) {}
    hx::SetTopOfStack(nullptr, false);
    return result;
}

// Get child at index (returns opaque pointer)
void* viewnode_get_child(void* node, int32_t index) {
    hx::SetTopOfStack(nullptr, true);
    void* result = nullptr;
    try {
        Dynamic hxNode = (hx::Object*)node;
        auto args = ::cpp::ObjectArray<Dynamic>(2, 2);
        args[0] = hxNode;
        args[1] = (int)index;
        Dynamic ret = ::Type_obj::callStatic(
            ::Type_obj::resolveClass(HX_CSTRING("sui.runtime.ViewNodeBridge")),
            HX_CSTRING("getChild"),
            args
        );
        if (ret != null()) result = ret.val_cast<hx::Object*>();
    } catch (...) {}
    hx::SetTopOfStack(nullptr, false);
    return result;
}

// Get text content
const char* viewnode_get_text(void* node) {
    hx::SetTopOfStack(nullptr, true);
    const char* result = "";
    try {
        Dynamic hxNode = (hx::Object*)node;
        auto args = ::cpp::ObjectArray<Dynamic>(1, 1);
        args[0] = hxNode;
        Dynamic ret = ::Type_obj::callStatic(
            ::Type_obj::resolveClass(HX_CSTRING("sui.runtime.ViewNodeBridge")),
            HX_CSTRING("getTextContent"),
            args
        );
        if (ret != null()) result = ret.val_cast<String>().__CStr();
    } catch (...) {}
    hx::SetTopOfStack(nullptr, false);
    return result;
}

// Get button label
const char* viewnode_get_button_label(void* node) {
    hx::SetTopOfStack(nullptr, true);
    const char* result = "";
    try {
        Dynamic hxNode = (hx::Object*)node;
        auto args = ::cpp::ObjectArray<Dynamic>(1, 1);
        args[0] = hxNode;
        Dynamic ret = ::Type_obj::callStatic(
            ::Type_obj::resolveClass(HX_CSTRING("sui.runtime.ViewNodeBridge")),
            HX_CSTRING("getButtonLabel"),
            args
        );
        if (ret != null()) result = ret.val_cast<String>().__CStr();
    } catch (...) {}
    hx::SetTopOfStack(nullptr, false);
    return result;
}

// Get button action ID
int32_t viewnode_get_button_action_id(void* node) {
    hx::SetTopOfStack(nullptr, true);
    int32_t result = -1;
    try {
        Dynamic hxNode = (hx::Object*)node;
        auto args = ::cpp::ObjectArray<Dynamic>(1, 1);
        args[0] = hxNode;
        Dynamic ret = ::Type_obj::callStatic(
            ::Type_obj::resolveClass(HX_CSTRING("sui.runtime.ViewNodeBridge")),
            HX_CSTRING("getButtonActionId"),
            args
        );
        result = (int)ret;
    } catch (...) {}
    hx::SetTopOfStack(nullptr, false);
    return result;
}

// Get string property
const char* viewnode_get_property(void* node, const char* key) {
    hx::SetTopOfStack(nullptr, true);
    const char* result = "";
    try {
        Dynamic hxNode = (hx::Object*)node;
        auto args = ::cpp::ObjectArray<Dynamic>(2, 2);
        args[0] = hxNode;
        args[1] = ::String(key);
        Dynamic ret = ::Type_obj::callStatic(
            ::Type_obj::resolveClass(HX_CSTRING("sui.runtime.ViewNodeBridge")),
            HX_CSTRING("getStringProperty"),
            args
        );
        if (ret != null()) result = ret.val_cast<String>().__CStr();
    } catch (...) {}
    hx::SetTopOfStack(nullptr, false);
    return result;
}

// Get modifier count
int32_t viewnode_modifier_count(void* node) {
    hx::SetTopOfStack(nullptr, true);
    int32_t result = 0;
    try {
        Dynamic hxNode = (hx::Object*)node;
        auto args = ::cpp::ObjectArray<Dynamic>(1, 1);
        args[0] = hxNode;
        Dynamic ret = ::Type_obj::callStatic(
            ::Type_obj::resolveClass(HX_CSTRING("sui.runtime.ViewNodeBridge")),
            HX_CSTRING("getModifierCount"),
            args
        );
        result = (int)ret;
    } catch (...) {}
    hx::SetTopOfStack(nullptr, false);
    return result;
}

// Get modifier type name at index
const char* viewnode_modifier_type(void* node, int32_t index) {
    hx::SetTopOfStack(nullptr, true);
    const char* result = "";
    try {
        Dynamic hxNode = (hx::Object*)node;
        auto args = ::cpp::ObjectArray<Dynamic>(2, 2);
        args[0] = hxNode;
        args[1] = (int)index;
        Dynamic ret = ::Type_obj::callStatic(
            ::Type_obj::resolveClass(HX_CSTRING("sui.runtime.ViewNodeBridge")),
            HX_CSTRING("getModifierType"),
            args
        );
        if (ret != null()) result = ret.val_cast<String>().__CStr();
    } catch (...) {}
    hx::SetTopOfStack(nullptr, false);
    return result;
}

// Get modifier float parameter
double viewnode_modifier_float(void* node, int32_t index, int32_t paramIndex) {
    hx::SetTopOfStack(nullptr, true);
    double result = 0.0;
    try {
        Dynamic hxNode = (hx::Object*)node;
        auto args = ::cpp::ObjectArray<Dynamic>(3, 3);
        args[0] = hxNode;
        args[1] = (int)index;
        args[2] = (int)paramIndex;
        Dynamic ret = ::Type_obj::callStatic(
            ::Type_obj::resolveClass(HX_CSTRING("sui.runtime.ViewNodeBridge")),
            HX_CSTRING("getModifierFloat"),
            args
        );
        result = (double)ret;
    } catch (...) {}
    hx::SetTopOfStack(nullptr, false);
    return result;
}

// Get root view node (returns opaque pointer)
void* viewnode_get_root(void) {
    hx::SetTopOfStack(nullptr, true);
    void* result = nullptr;
    try {
        Dynamic ret = ::Type_obj::callStatic(
            ::Type_obj::resolveClass(HX_CSTRING("sui.runtime.ViewNodeBridge")),
            HX_CSTRING("getRoot"),
            ::cpp::ObjectArray<Dynamic>(0, 0)
        );
        if (ret != null()) result = ret.val_cast<hx::Object*>();
    } catch (...) {}
    hx::SetTopOfStack(nullptr, false);
    return result;
}

} // extern "C"
