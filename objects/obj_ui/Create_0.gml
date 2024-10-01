drawn_score = score;
shake_magnitude = 0;
shake_time = 0;
shake_fade = 0;
shake = false;
shake_x_offset = 0;
shake_y_offset = 0;
tutorial_banner_x = 0;
tutorial_banner_center_point = global.first_wave_complete ? -2000 : 0;
tutorial_banner_y = room_height/6;
tutorial_text_padding_left = 40;
show_tutorial = get_flag("needs_tutorial");

shake_text = function(_time = 0, _magnitude = 0, _fade_rate = 0) {
	shake_time = _time;
	shake_magnitude = _magnitude;
	shake_fade = _fade_rate;
	shake = true;
}