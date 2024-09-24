// dont' spawn while still in the tutorial phase
if (global.tutorial) {
	return;
}

// give enemy types a value to determine if they will "fit" into the the room, i.e. if spawning them will be too overwhelming for the player at the given moment
var _enemy_types = [obj_dot, obj_dot, obj_dot, obj_growing_dot, obj_big_dot, obj_big_dot];
var _enemy_values = [[obj_growing_dot, 1], [obj_growing_dot, 2], [obj_big_dot, 3]];
var _max_value = 10;

// countdown to next spawn
var _current_enemy_count = instance_number(obj_dot);
if (_current_enemy_count < max_enemy_count && spawn_timer > 0) {
	spawn_timer--;
}

// when it's time for the next spawn, calculate the value of an enemy spawn to determine if it will fit in the room
if (spawn_timer <= 0) {
	
	if (score >= 400) {
		global.first_wave_complete = true;
	}
	
	// get the target enemy type to spawn
	var _chosen_spawn_point = spawn_points[irandom_range(0, array_length(spawn_points)-1)];
	var _chosen_spawn_type = _enemy_types[irandom_range(0, array_length(_enemy_types)-1)];
	var _total_enemy_value = instance_number(obj_dot) + (instance_number(obj_big_dot) * 2) + instance_number(obj_growing_dot);

	// get the value of the chosen spawn
	var _chosen_spawn_type_value = 0;
	for (var _i = 0; _i < array_length(_enemy_values); _i++) {
		if (_enemy_values[_i][0] == _chosen_spawn_type) {
			_chosen_spawn_type_value = _enemy_values[_i][1];
		}
	}
	
	if (!global.first_wave_complete && score < 400) {
		_chosen_spawn_type = obj_dot;
	}

	// if the value is not too large, spawn the enemy
	var _repeated_spawn_point = previous_spawn_point.x_pos == _chosen_spawn_point.x_pos && previous_spawn_point.y_pos == _chosen_spawn_point.y_pos;
	if (_total_enemy_value + _chosen_spawn_type_value <= _max_value && !_repeated_spawn_point) {
		instance_create_layer(_chosen_spawn_point.x_pos, _chosen_spawn_point.y_pos, layer, _chosen_spawn_type);
		spawn_timer = time_between_spawns;
	}
	
}

// raise max enemy count with player score
max_enemy_count = 1 + floor((score / 400));