draw_self();
draw_sprite_ext(spr_white_dot, 0, x, y, image_xscale, image_yscale, 0, WHITE, image_xscale / max_scale);
if (!hit) {
	draw_sprite_ext(shield_sprite, 0, x, y, image_xscale, image_yscale, 0, WHITE, 0.8);
}