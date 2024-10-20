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
	
	spawn_particles(part_death, x, y);
}

publish(ENEMY_DEFEATED, point_value);

unsubscribe_all(id);