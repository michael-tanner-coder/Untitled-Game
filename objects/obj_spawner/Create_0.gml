
// waves:
// last for specific number of enemies
// defeating all enemies will end the wave
// enemies spawn at set intervals during the wave
// maximum number of enemies allowed in a wave increases with time

wave_index = 0;
total_wave_count = 5;
wave_enemy_count = 15;
enemies_spawned = 0;
enemies_remaining = wave_enemy_count;
wave_time = 0;
wave_enemy_types = [obj_dot, obj_dot, obj_dot, obj_big_dot, obj_growing_dot];

max_enemy_count = 10;
time_between_spawns = 30;
spawn_timer = 30;
previous_spawn_point = {x_pos: 0, y_pos: 0};

var _temp_spawn_points = [];
with(obj_dot) {
    array_push(_temp_spawn_points, {x_pos: x, y_pos: y});
    
    instance_destroy(self);
}
spawn_points = _temp_spawn_points;

// State Machine
fsm = new SnowState("wave");
fsm.add("wave", {
	
	enter: function() {
		enemies_remaining = wave_enemy_count;
		spawn_timer = time_between_spawns;
		enemies_spawned = 0;
		wave_time = 0;
	},
	
	step: function() {
	
		if (enemies_remaining <= 0) {
			if (wave_index >= total_wave_count-1) {
				fsm.change("level_complete");
			}
			else {
				fsm.change("rest");
			} 
		}
		
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
			var _chosen_spawn_type = wave_enemy_types[irandom_range(0, array_length(wave_enemy_types)-1)];
			var _total_enemy_value = instance_number(obj_dot) + (instance_number(obj_big_dot) * 2) + instance_number(obj_growing_dot);
			
			if (!global.first_wave_complete && score < 400) {
				_chosen_spawn_type = obj_dot;
			}
		
			// if the value is not too large, spawn the enemy
			var _repeated_spawn_point = previous_spawn_point.x_pos == _chosen_spawn_point.x_pos && previous_spawn_point.y_pos == _chosen_spawn_point.y_pos;
			if (enemies_spawned < wave_enemy_count && _current_enemy_count < max_enemy_count && !_repeated_spawn_point) {
				instance_create_layer(_chosen_spawn_point.x_pos, _chosen_spawn_point.y_pos, layer, _chosen_spawn_type);
				spawn_timer = time_between_spawns;
				enemies_spawned++;
			}
			
		}
		
		// update max enemy count based on progress into the wave
		if (score >= 400) {
			wave_time += (delta_time/1000000);
			max_enemy_count = 1 + floor((wave_time / 5));
		}
		else {
			max_enemy_count = 1;
		}
	},
	
	draw: function() {
		fillbar(room_width/2 - 100, room_height - 60, 200, 50, 1 - (enemies_remaining/wave_enemy_count), RED, PURPLE);
		draw_set_halign(fa_center);
		draw_shadow_text(room_width/2, room_height - 60, "WAVE" + string(wave_index + 1) + "/" + string(total_wave_count));
	}
	
});

fsm.add("rest", {
	enter: function() {
		wave_index++;
	},
	
	step: function() {
		var _current_enemy_count = instance_number(obj_dot);
		if (_current_enemy_count <= 0 && input_check_pressed("select")) {
			fsm.change("wave");
		}
	},
	
	draw: function() {
		fillbar(room_width/2 - 100, room_height - 60, 200, 50, 1, RED, PURPLE);
		draw_set_halign(fa_center);
		draw_shadow_text(room_width/2, room_height - 60, "REST...");
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
	},
}); 

// Event Subscriptions
subscribe(id, ENEMY_DEFEATED, function() {
	enemies_remaining--;
});
