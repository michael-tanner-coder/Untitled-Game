load_character_queue();

// Prompt
show_debug_message("GETTING CURRENT SCENE");
var _current_scene = get_current_scene();

if (_current_scene) {
    show_debug_message("FOUND CURRENT SCENE");
    with(obj_tip_prompt) {
        show_debug_message(header_text);
        header_text = struct_get(_current_scene, "header");
        tip_text = struct_get(_current_scene, "tip");
    }
}

// Character Animations

// store all character positions for later use
var _character_positions = [];
with(obj_empty) {
    array_push(_character_positions, {obj_x: self.x, obj_y: self.y, key: self.character_key});
}
character_positions = _character_positions;

find_character_pos = function(key = "") {
    
    var _pos = {obj_x: 0, obj_y: 0};
    
    FOREACH character_positions ELEMENT
        if (_elem.key == key) {
            _pos.obj_x = _elem.obj_x;
            _pos.obj_y = _elem.obj_y;
        }
    END
    
    return _pos;
    
}

// remove all current sequence from the room so that we have a clean slate
var _character_layer_elements = layer_get_all_elements("Characters");
FOREACH _character_layer_elements ELEMENT
    if layer_get_element_type(_elem) == layerelementtype_sequence
    {
        layer_sequence_destroy(_elem);
    }
END


// use the stored character positions to restore animations of all unlocked characters
FOREACH global.character_queue ELEMENT
    var _character = global.character_properties[_elem];
    var _walk_cycle = struct_get(_character, "walk_cycle");
    var _key = struct_get(_character, "key");
    show_debug_message(_key);
    
    if (_walk_cycle) {
        var _pos = find_character_pos(_key);
        show_debug_message(_pos);
        layer_sequence_create("Characters", _pos.obj_x, _pos.obj_y, _walk_cycle);
    }
END
    