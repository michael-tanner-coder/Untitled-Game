if (disabled || ! focused) {
    draw_set_alpha(0.5);
}

// input box
draw_set_font(font);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
var _box_width = string_width("W") * (input_character_limit + 1);
var _box_height = string_height("W");
draw_sprite_stretched(sprite_index, 0, x, y, string_width("W") * (input_character_limit + 1), _box_height);

// animated text
var _text_shadow_renderer = scribble(input_string);
_text_shadow_renderer.starting_format("fnt_default", PURPLE).align(fa_left, fa_top).fit_to_box(string_width("W") * (input_character_limit), string_height("W")).draw((input_string_x + string_width("W")/2) + 2, input_string_y + 2, typist);
var _text_renderer = scribble(input_string);
_text_renderer.starting_format("fnt_default", WHITE).align(fa_left, fa_top).fit_to_box(string_width("W") * (input_character_limit), string_height("W")).draw(input_string_x + string_width("W")/2, input_string_y, typist);

// flickering cursor
if (flicker_time > 0) {
    var _cursor_height = string_height("W")/2;
    var _cursor_x = input_string_x + string_width(input_string) + string_width("W")/2;
    var _cursor_y = input_string_y + _cursor_height/2;
    draw_sprite_stretched_ext(spr_pixel, 0, _cursor_x, _cursor_y, cursor_width, _cursor_height, WHITE, 1);
}

// character limit
var _char_count = string_length(input_string);
var _limit_color = _char_count < input_character_limit ? WHITE : RED;
draw_shadow_text(x + _box_width + string_width("W")/2, y, string(_char_count) + "/" + string(input_character_limit), _limit_color, PURPLE);

// input label
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);
draw_shadow_text(x, y-label_margin, label, label_text_color);

// reset alpha
draw_set_alpha(1);