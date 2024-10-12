if (hit) {
    var _points = 200;
	score += _points;
	var _score_text = instance_create_layer(phy_position_x, phy_position_y, layer, obj_float_text);
	_score_text.text = "+" + string(_points);
	
	play_sound(snd_points, false);
	
	with(obj_ui) {
		shake_text(1, 4, 0.5);
	}
	
	spawn_particles(part_death, x, y);
	
	var _length = string_length(text);
	var _starting_index = (_length / 2) - 1;
	
	if (_length > 1) {
    	var _first_half_string = string_copy(text, 0, (_length/2) - 1)
    	var _second_half_string = string_copy(text, _starting_index, (_length/2) - 1);
    	
    	var _first_text = instance_create_layer(phy_position_x, phy_position_y, layer, obj_physics_text);
    	_first_text.text = _first_half_string;
    	_first_text.remove_previous_fixture();
    	_first_text.set_physics_fixture();
    	
	    // 	var _second_text = instance_create_layer(phy_position_x, phy_position_y, layer, obj_physics_text);
	    // 	_second_text.text = _second_half_string;
	    // 	_second_text.remove_previous_fixture();
	    // 	_second_text.set_physics_fixture();
	}
	
	instance_destroy(self);
}