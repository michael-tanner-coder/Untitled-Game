spawn_types = struct_get(get_current_scene(), "enemies");
time_between_spawns = struct_get(get_current_scene(), "spawn_rate");
spawn_limit = struct_get(get_current_scene(), "spawn_limit");
spawning_enabled = true;
spawn_sequence = undefined;
spawn_alarm = 0;
chosen_spawn_pipe = {};
chosen_spawn_type = undefined;
spawn_count = 0;
spawn_timer = -1;
default_key_enemy_spawn_chance = 25; // pull this random stat from a spreadsheet
key_spawn_chance = default_key_enemy_spawn_chance; 

var _spawn_pipes = [];
with(obj_spawn_point) {
	array_push(_spawn_pipes,self);
}
spawn_pipes = _spawn_pipes;

// events
subscribe(id, LEVEL_ENDED, function() {
	spawning_enabled = false;
});

subscribe(id, ENABLED_ENEMY_SPAWNING, function() {
	spawning_enabled = true;
});

subscribe(id, DISABLED_ENEMY_SPAWNING, function() {
	show_debug_message("DISABLING SPAWNS");
	spawning_enabled = false;
});

subscribe(id, SPAWN_ONLY_KEY_ENEMIES, function() {
	key_spawn_chance = 100;
});

subscribe(id, SPAWN_NO_KEY_ENEMIES, function() {
	key_spawn_chance = 0;
});

subscribe(id, RESET_KEY_ENEMY_SPAWN_CHANCE, function() {
	key_spawn_chance = default_key_enemy_spawn_chance;
});

manager_spawn_enemy = function() {
	var _new_enemy = instance_create_layer(chosen_spawn_pipe.x, chosen_spawn_pipe.y, layer, chosen_spawn_type);
	_new_enemy.xspd *= _new_enemy.x > room_width/2 ? -1 : 1;
	_new_enemy.has_key = key_spawn_chance > 0 && random_range(1, 100) < key_spawn_chance && !key_enemy_exists();
	if (_new_enemy.has_key && _new_enemy.shiny_sprite && _new_enemy.use_sprites) {
		_new_enemy.sprite_index = _new_enemy.shiny_sprite;
	}
}