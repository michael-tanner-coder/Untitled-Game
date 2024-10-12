time_between_spawns--;
if (time_between_spawns <= 0 && current_line <= array_length(credits) - 1) {
	time_between_spawns = max_time_between_spawns;
	
	var _next_text = instance_create_layer(x, y, layer, obj_physics_text);
	var _credit = credits[current_line];
	_next_text.text = _credit;
	_next_text.remove_previous_fixture();
	_next_text.set_physics_fixture();
	
	with(_next_text) {
		physics_apply_impulse(x, y, 0, -180);
	}
	
	current_line++;
}