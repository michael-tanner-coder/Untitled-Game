load_character_queue();
stop_current_stinger();
progress_input_key = "progress";
skip_input_key = "skip";

// Textboxes
dialogue_box = instance_create_layer(x, y, layer, obj_text_box);

// Prompt and Dialogue Box
show_debug_message("GETTING CURRENT SCENE");
var _current_scene = get_current_scene();

if (_current_scene) {
    show_debug_message("FOUND CURRENT SCENE");
    
    // load text into tip prompt, if available
    with(obj_tip_prompt) {
        show_debug_message(header_text);
        header_text = struct_get(_current_scene, "header");
        tip_text = struct_get(_current_scene, "tip");
    }
    
    // get status of unlocked character
    var _character_type = struct_get(_current_scene, "character_type");
    var _character_already_unlocked = character_is_unlocked(_character_type);
    
    // add unlocked character to queue
    if (!_character_already_unlocked && is_numeric(_character_type)) {
        unlock_character(_character_type);
        add_to_character_queue(_character_type);
        play_stinger(snd_stinger_character_unlock);
    }
    
    // get cutscene dialogue and paginate it
    var _dialogue_sets = struct_get(_current_scene, "dialogue_sets");
    if (is_array(_dialogue_sets) && array_length(_dialogue_sets) > 1) {
        // choose the default dialogue if this is the first time meeting the character; otherwise, get a random dialogue sequence
        var _dialogue_array = _character_already_unlocked ? _dialogue_sets[irandom_range(1, array_length_1d(_dialogue_sets) - 1)] : _dialogue_sets[0];
        var _paginated_diaglogue = "";
        
        FOREACH _dialogue_array ELEMENT
            // add the dialogue line's text to the list of paginated dialogue
            _paginated_diaglogue = string_concat(_paginated_diaglogue, _elem);
            
            // only add a new page break if we are not on the last line of dialogue
            if (_i < array_length(_get_list) - 1) {
                _paginated_diaglogue = string_concat(_paginated_diaglogue, "[/page]");
            }
        END
        
        dialogue_box.text_content = _paginated_diaglogue;
        dialogue_box.pages = _dialogue_array;
    }
    
}

// Remove any characters that are not unlocked
with (obj_cutscene_character_normal) {
    if (self.character != undefined && !array_contains(global.character_queue, self.character)) {
        layer_sequence_destroy(self.active_sequence);
        instance_destroy(self);
    }
    else {
        layer_sequence_speedscale(self.active_sequence, random_range(0.75, 1));
    }
}
