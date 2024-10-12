if (hit) {
	set_text_color_from_health();
}

if (hit_timer > 0) {
    hit_timer--;
}

if (hit_timer <= 0) {
    hit = false;
}

if (text_health <= 0) {
	score += point_value;
	var _score_text = instance_create_layer(phy_position_x, phy_position_y, layer, obj_float_text);
	_score_text.text = "+" + string(point_value);
	
	play_sound(snd_points, false);
	
	with(obj_ui) {
		shake_text(1, 4, 0.5);
	}
	
	spawn_particles(part_death, x, y);
	
	instance_destroy(self);
}

text_alpha = lerp(text_alpha, 1, 0.02);

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
