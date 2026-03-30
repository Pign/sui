#ifndef VIEWNODE_BRIDGE_H
#define VIEWNODE_BRIDGE_H

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

// --- View tree lifecycle ---
void viewnode_rebuild(void);
void* viewnode_get_root(void);

// --- Node accessors ---
const char* viewnode_get_type(void* node);
int32_t viewnode_child_count(void* node);
void* viewnode_get_child(void* node, int32_t index);

// --- Properties ---
const char* viewnode_get_property(void* node, const char* key);

// --- Text ---
const char* viewnode_get_text(void* node);

// --- Button ---
const char* viewnode_get_button_label(void* node);
int32_t viewnode_get_button_action_id(void* node);

// --- Modifiers ---
int32_t viewnode_modifier_count(void* node);
const char* viewnode_modifier_type(void* node, int32_t index);
double viewnode_modifier_float(void* node, int32_t index, int32_t paramIndex);

#ifdef __cplusplus
}
#endif

#endif // VIEWNODE_BRIDGE_H
