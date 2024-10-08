// Get scene data
var _current_scene = get_current_scene();
if (_current_scene == undefined) {
	_current_scene = {
		goal_score: 20000,
        time_between_spawns: 30,
        max_enemy_count: 10,
	};
}

// Current Scene Configurations
enemy_types = _current_scene.enemy_types;
modified_time_between_spawns = _current_scene.time_between_spawns;
current_max_enemy_count = _current_scene.max_enemy_count;
goal_score = _current_scene.goal_score;

// Set Spawner properties
base_time_between_spawns = 30;
spawn_timer = base_time_between_spawns;
previous_spawn_point = {x_pos: 0, y_pos: 0};
tutorial_score = 400; // make this configurable
upgrade_score = 2000; // make this configurable
raise_tension = true;

// Spawn Point Setup
var _temp_spawn_points = [];
with(obj_dot) {
    array_push(_temp_spawn_points, {x_pos: x, y_pos: y});
    instance_destroy(self);
}
spawn_points = _temp_spawn_points;

// State Machine
fsm = new SnowState("wave");
fsm.add("wave", {
	step: function() {
		
		// update background animation based on level progress
		if (score >= tutorial_score) {
			var _level_progress = (score/goal_score);
			var _bg_speed = 1 + (7 * _level_progress);
			var _back_layer = layer_get_id("Background");
			var _back_layer_1 = layer_get_id("Background_1");
			layer_hspeed(_back_layer, _bg_speed);
			layer_vspeed(_back_layer, _bg_speed);
			layer_hspeed(_back_layer_1, _bg_speed/2);
			layer_vspeed(_back_layer_1, _bg_speed/2);
		}
	
		// raise and lower tension of the level periodically after the initial wave
		if (global.first_wave_complete) {
			if (global.tension >= 1) {
				raise_tension = false;
			}
			
			if (global.tension <= 0) {
				raise_tension = true;
			}
			
			global.tension += (raise_tension ? 0.025 : -0.025) * DT;
		}
	
		
		// check for level progress based on score
		if (score >= goal_score) {
			fsm.change("level_complete");
		}
			
		// countdown to next spawn
		var _current_enemy_count = instance_number(obj_dot);
		if (_current_enemy_count < current_max_enemy_count && spawn_timer > 0) {
			spawn_timer--;
		}
	
		// when it's time for the next spawn, calculate the value of an enemy spawn to determine if it will fit in the room
		if (spawn_timer <= 0) {
			
			// turn off tutorial features once we reach an early point threshold
			if (score >= tutorial_score) {
				global.first_wave_complete = true;
			}
			
			// get the target enemy type to spawn
			var _chosen_spawn_point = spawn_points[irandom_range(0, array_length(spawn_points)-1)];
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
				instance_create_layer(_chosen_spawn_point.x_pos, _chosen_spawn_point.y_pos, layer, _chosen_spawn.type);
				spawn_timer = base_time_between_spawns + (modified_time_between_spawns * (1 - global.tension));
			}
			
		}
		
		// update max enemy count based on progress into the wave
		current_max_enemy_count = 1 + ceil(9 * global.tension);
		current_max_enemy_count = clamp(current_max_enemy_count, 1, 10);
		
		// keep spawn count low when player is first learning
		if (!global.first_wave_complete) {
			current_max_enemy_count = 1;
		}

	},
});

fsm.add("idle", {
	enter: function() {
	},
	
	step: function() {
	},
	
	draw: function() {
	}
});

fsm.add("level_complete", {
	enter: function() {
		
	},
	step: function() {
		
	},
	draw: function() {
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_shadow_text(room_width/2, room_height/2, "LEVEL COMPLETE");
		draw_shadow_text(room_width/2, room_height/2 + 80, "FINAL SCORE: " + string(score));
	},
}); 

// Event Subscriptions
subscribe(id, ACTORS_DEACTIVATED, function() {fsm.change("idle")});
subscribe(id, ACTORS_ACTIVATED, function() {fsm.change("wave")});