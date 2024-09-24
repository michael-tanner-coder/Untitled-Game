if (!current_prompt || tutorial_ended) {
    return; 
}

var _prompt_x = room_width/2;
var _prompt_y = room_height/2 - 128;

var _typing_finished = typist.get_state() == 1;

// Prompt box
draw_sprite_stretched_ext(spr_tutorial_prompt, 0, _prompt_x-textbox_width/2, _prompt_y-textbox_width/2, textbox_width, textbox_height, c_white, 1);

// Prompt header
draw_set_color(WHITE);
var _full_prompt_string = "";

var _prompt_text = struct_get(current_prompt, "text");
if (is_string(_prompt_text)) {
    _full_prompt_string = string_concat(_full_prompt_string, _prompt_text);
}

// Prompt input count
var _prompt_count = struct_get(current_prompt, "count")
if (_prompt_count) {
    var _count_string = string(current_prompt_count) + "/" + string(_prompt_count);
    if (prompt_typing_finished && current_prompt_count > 0 && text_animation_time > 0) {
        _count_string = "[pulse][YELLOW]"+ string(current_prompt_count) + "[/YELLOW][/pulse][c_white]" + "/" + string(_prompt_count);
    }
    _full_prompt_string = string_concat(_full_prompt_string, "\n" + _count_string);
}

// Prompt input icons
var _prompt_inputs = struct_get(current_prompt, "inputs");
if (is_array(_prompt_inputs)) {
    _full_prompt_string = string_concat(_full_prompt_string, "\n");
    FOREACH _prompt_inputs ELEMENT
        var _input = _elem;
        var _input_sprite = input_verb_get_icon(_input);
        var _input_is_pressed = input_check(_input)
        if (_input_sprite != undefined) {
            if (prompt_typing_finished && (_input_is_pressed || text_animation_time > 0)) {
                _full_prompt_string = string_concat(_full_prompt_string, "[pulse][YELLOW][" + sprite_get_name(_input_sprite) +"][/pulse][c_white]")
            }
            else {
                _full_prompt_string = string_concat(_full_prompt_string, "[" + sprite_get_name(_input_sprite) +"]")
            }
        }
    END
}

// Scribble render
if (!prompt_typing_finished) {
    var _text_renderer = scribble(_full_prompt_string);
    _text_renderer.starting_format("fnt_cutscene_default", WHITE).align(fa_center, fa_middle).fit_to_box(textbox_width - padding_x, textbox_height - padding_y).draw(_prompt_x, _prompt_y - 64, typist);
}
else {
    var _text_renderer = scribble(_full_prompt_string);
    _text_renderer.starting_format("fnt_cutscene_default", WHITE).align(fa_center, fa_middle).fit_to_box(textbox_width - padding_x, textbox_height - padding_y).draw(_prompt_x, _prompt_y - 64);
}