stop_current_stinger();
progress_input_key = "down";

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
    
    var _music_layers = struct_get(_current_scene, "music_layers");
    if (is_array(_music_layers)) {
        play_layered_track(_music_layers, true);
    }
}

// Character Animations
return; // TODO: remove this lol

// store all character positions for later use
var _character_positions = [];
with(obj_empty) {
    array_push(_character_positions, self);
}
character_positions = _character_positions;

find_character_pos = function(key = "") {
    
    var _empty = undefined;
    
    FOREACH character_positions ELEMENT
        if (_elem.character_key == key) {
            _empty = _elem;
        }
    END
    
    return _empty;
    
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
    var _key = struct_get(_character, "key");
    var _idle_sprite = struct_get(_character, "idle");
    show_debug_message(_key);
    
    var _empty_obj = find_character_pos(_key);
    if (_empty_obj && _idle_sprite) {
        _empty_obj.sprite_index = _idle_sprite;
        _empty_obj.vspeed = 8;
    }
END
    