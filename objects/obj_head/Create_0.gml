event_inherited();

target_character = undefined;
min_float_height = sprite_get_height(sprite_index);
mid_float_height = sprite_get_height(sprite_index) * 4;
max_float_height = sprite_get_height(sprite_index) * 9;
float_height = min_float_height;
base_y = y;
warping_enabled = false;
use_sprites = true;

moving_entrance_behavior = function() {
	with (obj_player) {
		target_character = self;
	}
}

moving_behavior = function() {
	
	// toggle floating position of head when up key is pressed
	if (input_check_pressed("up") && float_height != min_float_height) {
		float_height = min_float_height;
		play_sound(snd_head_float, false, 0.6);
	}
	else if (input_check_pressed("up") && float_height != max_float_height) {
		float_height = max_float_height;
		play_sound(snd_head_float, false, 1.1);
	}
	
	// Screenwrapping
	// if (is_screenwrapping && target_character != undefined) {
	// 	float_height = -1 * (distance_to_object(target_character) - mid_float_height);
	// 	is_screenwrapping = false;
	// }

	if (target_character != undefined) {
		x = target_character.x + (10 * target_character.facing_direction);
		base_y = lerp(base_y, target_character.y - float_height, 0.1);
		y = sine_wave(current_time / 2000, 1, 6, base_y);
		image_xscale = target_character.image_xscale;
	}
	
	// Actor collision
	var _actor_collisions = actor_collision(global.enemy_list);
	if (state != ACTOR_STATE.HURT && instance_exists(_actor_collisions.colliding_instance) && _actor_collisions.colliding_instance.lethal && iframes <= 0) {
		with (target_character) {
			change_state(ACTOR_STATE.HURT);
			publish("lost_life", 0);
		}
		iframes = 60;
	}
	check_for_vulnerable_actor(_actor_collisions.colliding_instance);
	
	// End of frame cleanup
	update_iframes();
	
}

states_array[ACTOR_STATE.MOVING] = {
	active_behavior: moving_behavior,
	entrance_behavior: moving_entrance_behavior,
	exit_behavior: function() {},
};

change_state(ACTOR_STATE.MOVING);