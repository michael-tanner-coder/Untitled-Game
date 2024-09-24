// don't spawn anything if the spawning process is disabled
if (!spawning_enabled) {
	return;
}

if (spawn_count < spawn_limit) {
	spawn_timer--;
}

if (spawn_timer == 0) {
	if (array_length(spawn_pipes) <= 0) {
		return;
	}

	var _chosen_spawn_pipe = {};
	var _chosen_spawn_type = undefined;
	
	// choose a spawnee and spawn point (do not select the same spawn point twice in a row)
	do {
		_chosen_spawn_pipe = spawn_pipes[irandom_range(0, array_length_1d(spawn_pipes)-1)];
		_chosen_spawn_type = spawn_types[irandom_range(0, array_length_1d(spawn_types)-1)];
	} until(_chosen_spawn_pipe != chosen_spawn_pipe || array_length(spawn_pipes) == 1)
	
	// create enemy spawn sequence
	if (spawn_count < spawn_limit && _chosen_spawn_pipe && _chosen_spawn_type) {
		spawn_sequence = layer_sequence_create(layer, _chosen_spawn_pipe.x, _chosen_spawn_pipe.y, seq_enemy_spawn);
		play_sound(snd_spawn, false);
	}
	
	chosen_spawn_pipe = _chosen_spawn_pipe;
	chosen_spawn_type = _chosen_spawn_type;
}

// reset spawn timer
if (spawn_count < spawn_limit && is_numeric(time_between_spawns) && spawn_timer <= 0 && (spawn_sequence == undefined || !sequence_exists(spawn_sequence))) {
	spawn_timer = time_between_spawns;
}

// spawn enemy
if (spawn_sequence != undefined && layer_sequence_exists(layer, spawn_sequence) && layer_sequence_is_finished(spawn_sequence)) {
	manager_spawn_enemy();
	layer_sequence_destroy(spawn_sequence);
}