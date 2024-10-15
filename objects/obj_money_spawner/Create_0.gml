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
modified_time_between_spawns = _current_scene.time_between_spawns;
current_max_money_count = 1;
goal_score = _current_scene.goal_score;

// Set Spawner properties
base_time_between_spawns = 100;
spawn_timer = base_time_between_spawns;
previous_spawn_point = {x_pos: 0, y_pos: 0};

// State Machine
fsm = new SnowState("wave");
fsm.add("wave", {
	step: function() {
		
		// don't spawn until we finish the tutorial and the first wave of enemies
		if (global.tutorial || !global.first_wave_complete) {
			return;
		}
	
		// countdown to next spawn
		var _current_money_count = instance_number(obj_money);
		if (_current_money_count < current_max_money_count && spawn_timer > 0) {
			spawn_timer--;
		}
	
		// when it's time for the next spawn, calculate the value of an enemy spawn to determine if it will fit in the room
		if (spawn_timer <= 0 && is_array(struct_get(global.current_layout, "money_spawn_points"))) {
			
			// get the target enemy type to spawn
			var _spawn_points = global.current_layout.money_spawn_points;
			var _chosen_spawn_point = _spawn_points[irandom_range(0, array_length(_spawn_points)-1)];
			var _chosen_spawn = obj_money;
			var _count_of_spawn_type = instance_number(_chosen_spawn);
			
			// if the value is not too large, spawn the enemy
			var _repeated_spawn_point = previous_spawn_point.x_pos == _chosen_spawn_point.x_pos && previous_spawn_point.y_pos == _chosen_spawn_point.y_pos;
			if	(
					_current_money_count < current_max_money_count && 
					!_repeated_spawn_point
				) 
			{
				previous_spawn_point = _chosen_spawn_point;
				instance_create_layer(_chosen_spawn_point.x_pos, _chosen_spawn_point.y_pos, layer, _chosen_spawn);
				spawn_timer = base_time_between_spawns + random_range(50, 100);
			}
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
	},
}); 

// Event Subscriptions
subscribe(id, ACTORS_DEACTIVATED, function() {fsm.change("idle")});
subscribe(id, ACTORS_ACTIVATED, function() {fsm.change("wave")});
subscribe(id, WON_LEVEL, function() {fsm.change("level_complete")});