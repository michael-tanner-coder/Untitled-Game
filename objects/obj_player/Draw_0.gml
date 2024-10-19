// draw_self();
if (fsm.event_exists("draw")) {
	fsm.draw();
}

// Flicker rendering when iframes are active
if (i_frames % 8 != 0) {
	draw_sprite_ext(spr_shield, 0, x, y, image_xscale, image_yscale, 0, WHITE, 1);
}