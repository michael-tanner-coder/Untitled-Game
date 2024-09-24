if (use_sprites) {
	draw_sprite_ext(sprite_index, 0, x + xoffset, y + yoffset, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}

if (global.debug) {
	draw_text(x, y - sprite_get_height(sprite_index), string(state));
}