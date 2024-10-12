time_between_spawns--;
	

if (time_between_spawns <= 0 && current_line <= array_length(credits) - 1) {
	var _credit_struct = credits[current_line];
	
	if (current_line == array_length(credits) - 1 && instance_number(obj_physics_text) > 0) {
		return;
	} 
	
	var _next_text = instance_create_layer(x, y, layer, obj_physics_text);
	
	_next_text.text = _credit_struct.text;
	_next_text.font = _credit_struct.font;
	_next_text.text_health = _credit_struct.text_health;
	_next_text.remove_previous_fixture();
	_next_text.set_physics_fixture();
	
	time_between_spawns = _credit_struct.time_before_next_spawn;
	
	with(_next_text) {
		physics_apply_impulse(x, y, 0, -180);
	}
	
	current_line++;
}