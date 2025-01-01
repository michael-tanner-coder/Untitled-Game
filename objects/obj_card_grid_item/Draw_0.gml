if (disabled) {
    draw_set_alpha(0.5);
}

draw_self();

draw_shadow_text(x, y - sprite_get_height(sprite_index)/2, card_data.id);

draw_set_alpha(1);