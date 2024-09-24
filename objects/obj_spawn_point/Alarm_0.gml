
// // choose spawn type
// if (!is_array(spawn_types)) {
// 	return;
// }
// var _chosen_spawn_type = spawn_types[irandom_range(0, array_length_1d(spawn_types)-1)];

// // get number of currently active enemies
// var _spawn_count = 0;
// FOREACH spawn_types ELEMENT
// 	_spawn_count += instance_number(_elem);
// END

// // spawn enemy
// if (_chosen_spawn_type && _spawn_count < spawn_limit) {
// 	instance_create_layer(x,y,layer,_chosen_spawn_type);
// }

// // reset spawn timer
// if (is_numeric(time_between_spawns)) {
// 	alarm_set(0, time_between_spawns);
// }