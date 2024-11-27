if (fsm.event_exists("draw")) {
	fsm.draw();
}

draw_8_direction_movement(spr_white_enemy_sheet, frame_width, frame_height, anim_length, image_xscale/max_scale, image_blend, (frame_width * image_xscale)/2, (frame_height * image_yscale)/2);

// if (!hit) {
// 	draw_sprite_ext(shield_sprite, 0, x, y, image_xscale, image_yscale, 0, WHITE, 0.8);
// }