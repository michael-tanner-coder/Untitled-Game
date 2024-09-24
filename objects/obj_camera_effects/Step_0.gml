if (shake) { 
	show_debug_message(shake_time);
	shake_time -= 1; 
	
	var _xval = choose(-shake_magnitude, shake_magnitude); 
	var _yval = choose(-shake_magnitude, shake_magnitude); 
	camera_set_view_pos(VIEW, _xval, _yval); 
	camera_set_view_target(VIEW, noone);

	if (shake_time <= 0) 
	{ 
		shake_magnitude -= shake_fade; 

		if (shake_magnitude <= 0) 
		{ 
			camera_set_view_pos(VIEW, 0, 0); 
			shake = false; 
		} 
	} 
}
