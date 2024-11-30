draw_set_font(text_font);

draw_set_alpha(opacity);

if (text_sprite != undefined) {
    draw_sprite_ext(text_sprite, 0, x + text_sprite_offset_x, y + text_sprite_offset_y, 1, 1, 0, c_white, opacity);
}
draw_shadow_text(x, y, text, WHITE);

draw_set_alpha(1);