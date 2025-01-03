// Get scene data
var _current_scene = get_current_scene();
if (_current_scene == undefined) {
	_current_scene = {
		goal_score: 20000,
        time_between_spawns: 30,
        max_enemy_count: 10,
        boss: obj_boss_test,
	};
}

// Current Scene Configurations
enemy_types = _current_scene.enemy_types;
modified_time_between_spawns = _current_scene.time_between_spawns;
current_max_enemy_count = _current_scene.default_max_enemy_count;
default_max_enemy_count = current_max_enemy_count;
boss_max_enemy_count = _current_scene.boss_max_enemy_count;
goal_score = _current_scene.goal_score;
boss_type = _current_scene.boss;
boss_active = false;

// Set Spawner properties
base_time_between_spawns = 30;
spawn_timer = base_time_between_spawns;
previous_spawn_point = {x_pos: 0, y_pos: 0};
tutorial_score = 400; // make this configurable
upgrade_score = 2000; // make this configurable
raise_tension = true;
tension_increment = 0.01;

global.boss_lives = 3;

// State Machine
fsm = new SnowState("wave");
fsm.add("wave", {
	step: function() {
		
		if (global.tutorial) {
			return;
		}
		
		if (score >= tutorial_score) {
			// update background animation based on level progress
			var _level_progress = (score/goal_score);
			var _bg_speed = (3 + (5 * _level_progress)) * get_global_game_speed();
			var _back_layer = layer_get_id("Background");
			var _back_layer_1 = layer_get_id("Background_1");
			layer_hspeed(_back_layer, _bg_speed);
			layer_vspeed(_back_layer, _bg_speed);
			layer_hspeed(_back_layer_1, _bg_speed/2);
			layer_vspeed(_back_layer_1, _bg_speed/2);
			
			// turn off tutorial features once we reach an early point threshold
			global.first_wave_complete = true;
		}
	
		// raise and lower tension of the level periodically after the initial wave
		if (global.first_wave_complete || boss_active) {
			if (global.tension >= 1) {
				raise_tension = false;
			}
			
			if (global.tension <= 0) {
				raise_tension = true;
			}
			
			var _climax_multiplier = score >= (goal_score * 0.75) ? 2 : 1;
			global.tension += (raise_tension ? tension_increment * _climax_multiplier : -tension_increment ) * DT;
		}
		
		// check if we should spawn the boss
		if ((score >= goal_score && boss_type != undefined && !boss_active) || (global.dev_mode && input_check_pressed("spawn_boss"))) {
			with(obj_dot) {
				instance_destroy(self);
			}
			
			var _sprite = object_get_sprite(boss_type);
			var _sprite_height = sprite_get_height(_sprite);
			var _falling_spawn = instance_create_layer(obj_boss_spawn_point.x, -1*_sprite_height, "Instances", obj_falling_spawn);
			
			_falling_spawn.spawn_type = boss_type;
			_falling_spawn.target_y = obj_boss_spawn_point.x;
			_falling_spawn.spawn_height = _sprite_height;
			_falling_spawn.sprite_index = _sprite;
			_falling_spawn.shadow_sprite = spr_shadow_boss;
			
			boss_active = true;
				
			screenshake(4, 10, 0.5);
		}
		
		// dev tool to auto-defeat boss
		if (global.dev_mode && instance_number(boss_type) > 0 && input_check("kill_boss")) {
			with(boss_type) {
				instance_destroy(self);
			}
		}
			
		// countdown to next spawn
		var _current_enemy_count = instance_number(obj_dot) + instance_number(obj_falling_spawn);
		if (_current_enemy_count < current_max_enemy_count && spawn_timer > 0) {
			spawn_timer--;
		}
	
		// when it's time for the next spawn, calculate the value of an enemy spawn to determine if it will fit in the room
		if (spawn_timer <= 0 && is_array(struct_get(global.current_layout, "enemy_spawn_points"))) {
			
			// get the target enemy type to spawn
			var _spawn_points = global.current_layout.enemy_spawn_points;
			var _chosen_spawn_point = _spawn_points[irandom_range(0, array_length(_spawn_points)-1)];
			var _chosen_spawn = enemy_types[irandom_range(0, array_length(enemy_types)-1)];
			var _count_of_spawn_type = instance_number(_chosen_spawn.type);
			
			// if the value is not too large, spawn the enemy
			var _repeated_spawn_point = previous_spawn_point.x_pos == _chosen_spawn_point.x_pos && previous_spawn_point.y_pos == _chosen_spawn_point.y_pos;
			if	(
					score >= _chosen_spawn.points &&
					_current_enemy_count < current_max_enemy_count && 
					_count_of_spawn_type < _chosen_spawn.limit && 
					!_repeated_spawn_point
				) 
			{
				previous_spawn_point = _chosen_spawn_point;

				var _sprite = object_get_sprite(_chosen_spawn.type);
				var _sprite_height = sprite_get_height(_sprite);
				var _falling_spawn = instance_create_layer(_chosen_spawn_point.x_pos, -1 * _sprite_height, "Instances", obj_falling_spawn);

				_falling_spawn.spawn_type = _chosen_spawn.type;
				_falling_spawn.target_y = _chosen_spawn_point.y_pos;
				_falling_spawn.spawn_height = _sprite_height;
				_falling_spawn.sprite_index = _sprite;
				
				if (_chosen_spawn.type == obj_big_dot) {
					_falling_spawn.sprite_index = spr_falling_slime_yellow;
					_falling_spawn.image_xscale = 4;
					_falling_spawn.image_yscale = 4;
					_falling_spawn.shadow_sprite = spr_shadow_big;
				}
				
				spawn_timer = base_time_between_spawns + (modified_time_between_spawns * (1 - global.tension));
			}
			
		}
		
		// update max enemy count based on progress into the wave
		current_max_enemy_count = 1 + ceil(boss_active ? boss_max_enemy_count : default_max_enemy_count * global.tension);
		current_max_enemy_count = clamp(current_max_enemy_count, 1, default_max_enemy_count);
		
		// keep spawn count low when player is first learning
		if (!global.first_wave_complete && !boss_active) {
			current_max_enemy_count = 1;
		}

	},
});

fsm.add("boss_defeated", {
	step: function() {
		global.temp_game_speed = lerp(global.temp_game_speed, 0.3, 0.1);
		
		if (global.temp_game_speed <= 0.3) {
			play_sound(snd_tutorial_success);
			global.temp_game_speed = 1;
			publish(WON_LEVEL);
		}
	}
});

fsm.add("idle", {
	enter: function() {
	},
	
	step: function() {
		// dev tool to auto-defeat boss
		if (global.dev_mode && instance_number(boss_type) > 0 && input_check("kill_boss")) {
			with(boss_type) {
				instance_destroy(self);
			}
		}

	},
	
	draw: function() {}
});

fsm.add("level_complete", {
	enter: function() {
		play_stinger(snd_stinger_victory);
	},
	step: function() {},
	draw: function() {},
}); 

// Event Subscriptions
subscribe(id, ACTORS_DEACTIVATED, function() {fsm.change("idle")});
subscribe(id, ACTORS_ACTIVATED, function() {fsm.change("wave")});
subscribe(id, WON_LEVEL, function() {fsm.change("level_complete")});
subscribe(id, DEFEATED_BOSS, function() {fsm.change("boss_defeated")})