if (disabled || ! focused) {
    draw_set_alpha(0.5);
}

draw_set_font(font);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_sprite_stretched(sprite_index, 0, x, y, string_width("W") * (input_character_limit + 1), string_height("W"))
draw_shadow_text(input_string_x + string_width("W")/2, input_string_y, input_string, text_color, text_shadow_color);

draw_set_alpha(1);