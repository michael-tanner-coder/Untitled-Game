draw_set_color(WHITE);
if (next_unlock == undefined) {
	draw_text(x + sprite_get_width(outline_sprite)/2, y, "NO MORE UNLOCKS!");
	return;
}

if (is_numeric(next_unlock.required_points)) {
	var _progress_percent = progress_points / next_unlock.required_points;
	_progress_percent = clamp(_progress_percent, 0, 1);

	draw_set_halign(fa_center);
	draw_set_color(WHITE);

	var _formatted_points = string_format(round(progress_points), 0, 0);
	draw_text(x + sprite_get_width(outline_sprite)/2, y - sprite_get_height(outline_sprite) - bar_margin, _formatted_points + "/" + string(next_unlock.required_points));

	draw_sprite(spr_progress_bar_outline, 0, x, y);
	draw_sprite_ext(spr_progress_bar_fill, 0, x + outline_size, y + outline_size, _progress_percent, 1, 0, c_white, 1);

	draw_text(x + sprite_get_width(outline_sprite) / 2, y + sprite_get_height(outline_sprite) + (bar_margin*2), "PROGRESS TO NEXT UNLOCK");
}

if (fsm.event_exists("draw")) {
  fsm.draw();
}

