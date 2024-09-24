draw_self();

if (show_shot_delay_meter) {
	var _meter_x = x - meter_width/2;
	var _meter_y = y + (sprite_get_height(sprite_index) - meter_height) + 8;
	var _meter_width = _meter_x + (meter_width * (shot_timer / shot_delay_max));
	var _full_meter_width = _meter_x + meter_width;
	var _meter_height = _meter_y + meter_height;
	draw_set_color(meter_color);
	draw_rectangle(_meter_x, _meter_y, _full_meter_width, _meter_height, false);
	draw_set_color(RED);
	draw_rectangle(_meter_x, _meter_y, _meter_width, _meter_height, false);
}