if (disabled) {
    draw_set_alpha(0.5);
}

draw_self();
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fnt_medium);
// draw_shadow_text(x, y + sprite_get_height(sprite_index)-4, card_data.name);
draw_shadow_text(x, y + sprite_get_height(sprite_index)-4, card_data.id);

draw_set_alpha(1);