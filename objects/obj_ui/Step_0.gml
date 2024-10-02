drawn_score = lerp(drawn_score, score, 0.3);

if (shake) {
	shake_time -= 1;
	shake_x_offset = choose(-shake_magnitude, shake_magnitude); 
	shake_y_offset = choose(-shake_magnitude, shake_magnitude); 
	
	if (shake_time <= 0) 
	{ 
		shake_magnitude -= shake_fade; 

		if (shake_magnitude <= 0) 
		{ 
			shake_x_offset = 0;
			shake_y_offset = 0;
			shake = false; 
		}
	} 
}

if (global.first_wave_complete) {
	tutorial_banner_center_point = lerp(tutorial_banner_center_point, -2000, 0.02);
}

if (fsm.event_exists("step")) {
	fsm.step();
}