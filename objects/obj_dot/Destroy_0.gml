if (lives < 1) {
	return;
}

if (hit) {
	score += point_value;
	var _score_text = instance_create_layer(x,y,layer, obj_float_text);
	_score_text.text = "+" + string(point_value);
	play_sound(snd_points, false);
	with(obj_ui) {
		shake_text(1, 4, 0.5);
	}
	
	// Particle animation
	var _sys = part_system_create();
	part_particles_burst(_sys, x, y, part_death);
	
	return;
}