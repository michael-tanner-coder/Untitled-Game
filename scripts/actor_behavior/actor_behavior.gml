// Movement
function move() {
	
	yspd *= fall_speed; // slow down fall speed
	xforce *= force_friction;
	yforce *= force_friction;
	x += (xspd + xforce) * speed_factor;
	y += (yspd + yforce) * speed_factor;
	
	if (yforce <= 0.1) {
		yforce = 0;
	}
	
}

function enact_gravity() {
	yspd += actor_gravity;
}

function shake(_shake_time = 0, _shake_magnitude = 0) {
	
	if (!is_numeric(_shake_time) || !is_numeric(_shake_magnitude)) {
		show_debug_message("Error: one of the provided shake parameters is not a number");
		return;
	}
	
	var _xval = choose(-_shake_magnitude, _shake_magnitude);
	var _yval = choose(-_shake_magnitude, _shake_magnitude);
	xoffset = _xval;
	yoffset = _yval;

	if (_shake_time <= 0) 
	{
		if (_shake_magnitude <= 0) 
		{ 
			xoffset = 0;
			yoffset = 0;
		}
	}
	
}


// Collision
function pixel_check_collision(_collidable_objects = []) {
	
	// default collision details
	var _collision_struct = {
		collided_above: false,
		collided_below: false,
		collided_left: false,
		collided_right: false,
		colliding_instance: undefined,
	};

	// pixel check x-axis
	if (place_meeting(x + xspd, y, _collidable_objects)) {
	    var _pixel_check = sign(xspd);
	    while (!place_meeting(x + _pixel_check, y,  _collidable_objects)) {
	        x += _pixel_check;
	    }
	    
		// capture horizontal collision directions
	    if (_pixel_check > 0) {
	    	_collision_struct.collided_right = true;
	    }
	    
	    if (_pixel_check < 0) {
	    	_collision_struct.collided_left = true;
	    }

	    xspd = 0;
		
		touching_wall = true;
		
		_collision_struct.colliding_instance = instance_place(x, y + _pixel_check, _collidable_objects);
	}
	else {
		touching_wall = false;
	}
	
	// pixel check y-axis
	if (place_meeting(x, y + yspd, _collidable_objects)) {
	    var _pixel_check = sign(yspd);
	    while (!place_meeting(x, y + _pixel_check, _collidable_objects)) {
	        y += _pixel_check;
	    }
	    
	    // capture vertical collision directions
	    if (_pixel_check > 0) {
	    	_collision_struct.collided_below = true;
	    }
	    
	    if (_pixel_check < 0) {
	    	_collision_struct.collided_above = true;
	    }

	    yspd = 0;
		
		touching_ground = true;
		
		_collision_struct.colliding_instance = instance_place(x, y + _pixel_check, _collidable_objects);
	}
	else {
		touching_ground = false;
	}
	
	// if we're stuck in a block, find the last un-stuck place and move back to it 
	if (place_meeting(x, y, _collidable_objects)) {
		for(var _i = 0; _i < 1000; ++_i) {
			// Right
			if (!place_meeting(x + _i, y, _collidable_objects)) {
				x += _i;
				break;
			}
			
			// Left
			if (!place_meeting(x - _i, y, _collidable_objects)) {
				x -= _i;
				break;
			}
			
			// Up
			if (!place_meeting(x, y - _i, _collidable_objects)) {
				y -= _i;
				break;
			}
			
			// Down
			if (!place_meeting(x, y + _i, _collidable_objects)) {
				y += _i;
				break;
			}
			
			// Top Right
			if (!place_meeting(x + _i, y - _i, _collidable_objects)) {
				y -= _i;
				x += _i;
				break;
			}
			
			// Top Left
			if (!place_meeting(x - _i, y - _i, _collidable_objects)) {
				y -= _i;
				x -= _i;
				break;
			}
			
			// Bottom Right
			if (!place_meeting(x + _i, y + _i, _collidable_objects)) {
				y += _i;
				x += _i;
				break;
			}

			// Botom Left
			if (!place_meeting(x - _i, y + _i, _collidable_objects)) {
				y += _i;
				x -= _i;
				break;
			}
		}
	}

	// provide collision details
	return _collision_struct;
	
}

function actor_collision(_collidable_actors = []) {
	
	// default collision details
	var _collision_struct = {
		collided_above: false,
		collided_below: false,
		collided_left: false,
		collided_right: false,
		colliding_instance: undefined,
	};

	// check x-axis
	if (place_meeting(x + xspd, y, _collidable_actors)) {
	    var _direction_check = sign(xspd);

		_collision_struct.colliding_instance = instance_place(x, y + _direction_check, _collidable_actors);
		
		if (instance_exists(_collision_struct.colliding_instance)) {
			if (_collision_struct.colliding_instance.x < x) {
		    	_collision_struct.collided_left = true;
			}
			
			if (_collision_struct.colliding_instance.x > x) {
		    	_collision_struct.collided_right = true;
			}
		}
	}

	// check y-axis
	if (place_meeting(x, y + yspd, _collidable_actors)) {
	    var _direction_check = sign(yspd);
	    
		_collision_struct.colliding_instance = instance_place(x, y + _direction_check, _collidable_actors);
		
		if (instance_exists(_collision_struct.colliding_instance)) {
			if (_collision_struct.colliding_instance.y < y) {
		    	_collision_struct.collided_above = true;
			}
			
			if (_collision_struct.colliding_instance.y > y) {
		    	_collision_struct.collided_below = true;
			}
		}
	}
	
	// return collision details
	return _collision_struct;
	
}

function destroy_block(_block) {
	
	if (instance_exists(_block)) {
		_block.x = -1000;
		_block.inactive = true;
		_block.set_inactive_alarm(240);
	}

	publish(GRID_REBUILT, 0);
	
}

function bounce() {
	
	yspd = current_character.jump_spd;
	
	if (jump_timer > 0 || bounced) {
	    yspd = current_character.jump_spd;

	    if (bounced) {
	        yspd *= 2;
	        x_scale_factor = 0.8;
	        y_scale_factor = 1.2;
	    }

	    jump_timer--;

	    bounced = false;
	}
	
}

function check_for_lethal_collision(_colliding_actor) {
	
	if (state != ACTOR_STATE.HURT && _colliding_actor && _colliding_actor.lethal && iframes <= 0) {
		if (is_partner) {
			change_state(ACTOR_STATE.HURT);
			return;
		}

		change_state(ACTOR_STATE.HURT);
		publish("lost_life", 0);
	}
	
}

function check_for_vulnerable_actor(_colliding_actor) {
	
	if (_colliding_actor && _colliding_actor.state == ACTOR_STATE.FLIPPED && !_colliding_actor.invincible) {
		destroy_enemy(_colliding_actor);
		bounce();
	}
	
}

function destroy_enemy(_enemy) {

	if (_enemy.has_key) {
		layer_sequence_create("Sequences", x, y, seq_key_spawn);
	}
	
	spawn_enemy_destruction_particles(_enemy.x, _enemy.y);
	instance_destroy(_enemy);
	play_sound(snd_death, false);
	publish(ENEMY_DEFEATED);
	
}

// Jumping
function jump(_ground = undefined) {
	
	// check for collision to rest any ongoing jumps
	if (place_meeting(x, y + 1, _ground)) {
	    jump_count = 0;

	    if (!touching_ground) {
	        fall_speed = 1;				// reset fall speed when hitting the ground
	        touching_ground = true;
	    }
		
		coyote_time = max_coyote_time;
	} 
	else {
		coyote_time--;					// activate coyote time if we have just now left a platform
	    touching_ground = false;
	}
	
	// init jump
	if (jump_buffer_time > 0 && coyote_time > 0 && jump_count < max_jump_count) {
		jump_count++;
		
		var _jump_sound = struct_get(current_character, "jumping_sound");
		if (_jump_sound) {
			play_sound(_jump_sound, false);
		}

		// image_yscale *= 0.8;
		x_scale_factor = 0.6;
		spawn_dust_particles();
		jump_timer = jump_hold_frames;
	}
	
	// maintain jump speed based on timer
	if (jump_timer > 0) {
		yspd = jump_speed;
		jump_timer--;
	}
	
	// Jump Buffer + Coyote Time
	if (jump_buffer_time > 0) {
	    jump_buffer_time -= 1;
	}
	
	if (coyote_time < 0) {
		coyote_time = 0;
	}
	
}

function kill_jump() {
	jump_timer = 0;
	yspd = 0;
	jump_buffer_time = 0;
}


// Player Input
function process_player_input() {

	var _right_key = input_check("right");
	var _left_key = input_check("left");
	var _right_key_pressed = input_check_pressed("right");
	var _left_key_pressed = input_check_pressed("left");
	var _jump_key_pressed = input_check_pressed("jump");
	var _jump_key_hold = input_check("jump");
	var _jump_key_up = input_check_released("jump");
	var _up_key_pressed = input_check_released("up");
	var _down_key_held = input_check("down");
	var _down_key_pressed = input_check_pressed("down");
	
	xspd = (_right_key - _left_key) * (!is_partner ? move_speed : -1 * move_speed);
	
	// Movement Inputs
	if (_right_key || _left_key) {
		change_state(ACTOR_STATE.MOVING);
	}
	else {
		change_state(ACTOR_STATE.IDLE);
	}
	
	// Jump Inputs
	// don't initiate a jump if we aren't pressing the jump button
	if (_jump_key_up) {
		jump_buffer_time = 0;
		coyote_time = 0;
	}
	
	// activate jump
	if (_jump_key_pressed) {
		jump_buffer_time = max_jump_buffer_time;
	}
	
	// end jump early when letting go of button
	if (!_jump_key_hold) {
		jump_timer = 0;
	}
	
	// ground pound
	if (_down_key_pressed && !touching_ground && can_ground_pound) {
		fall_speed = 1;
		yforce = 2;
		ground_pound_active = true;
	}
	
	// fast fall
	if (_down_key_held) {
		fall_speed = 1;
		yforce = 2;
		
		if (!touching_ground) {
			publish(id, FELL_FAST);
		}
	}
	else {
		yforce = 0;
	}

}


// State machine
function change_state(_next_state = 0) {
	
	 if (state != _next_state) {
        script_execute(states_array[state].exit_behavior);
        script_execute(states_array[_next_state].entrance_behavior);
        previous_state = state;
		state = _next_state;
    }
	
}


// Screenwrapping
function check_for_screenwrap() {
	
	var _buffer = UNIT_SIZE;
	var _left_edge = view_xport[1];
	var _right_edge = view_xport[1] + camera_get_view_width(view_camera[1]);
	var _bottom_edge = view_yport[1] + camera_get_view_height(view_camera[1]);
	var _top_edge = view_yport[1];

	if (x >= _right_edge) {
		x = _left_edge + _buffer/2;
		return true;
	}

	if (x < _left_edge) {
		x = _right_edge - _buffer/2;
		return true;
	}
	
	if (y > _bottom_edge) {
		y = _top_edge;
		return true;
	}
	
	return false;

}

function check_for_level_bounds(_instance) {
	
	var _buffer = UNIT_SIZE;
	var _pillar_box_size = sprite_get_width(spr_pillar_box) * 6.5;
	var _left_edge = view_xport[1] + _pillar_box_size;
	var _right_edge = view_xport[1] + camera_get_view_width(view_camera[1]) - _pillar_box_size;

	if (_instance.x >= _right_edge) {
		_instance.x = _right_edge;
		return true;
	}

	if (_instance.x < _left_edge) {
		_instance.x = _left_edge;
		return true;
	}
	
	return false;

}

function screenwrap() {
	
	move_wrap(true, true, sprite_width / 2);

}

function flip_over() {
	
	if (touching_ground || state == ACTOR_STATE.FLIPPED) {
		yspd = -6;
		
		image_yscale = state != ACTOR_STATE.FLIPPED ? -1 : 1;
		
		yscale = image_yscale;
		
		change_state(state == ACTOR_STATE.FLIPPED ? ACTOR_STATE.MOVING : ACTOR_STATE.FLIPPED);
		
		publish(ENEMY_FLIPPED);
	}
	
}

// Animations
function switch_player_character_sequence(_new_player_sequence = "", _current_character = {}) {
	
	if (!is_string(_new_player_sequence)) {
		show_debug_message("Error: the provided player animation key is not a string");
		return;
	}
	
	if (!is_struct(_current_character)) {
		show_debug_message("Error: the provided character data is not a struct");
		return;
	}
	
	var _animation_cycle = struct_get(_current_character, _new_player_sequence);
	
	if (_animation_cycle) {
		switch_active_sequence(_animation_cycle);
	}
	
}

function switch_active_sequence(_new_sequence = undefined) {
	
	if (_new_sequence == undefined) {
		show_debug_message("Error: provided animation sequence is undefined");
		return;
	}
	
	layer_sequence_destroy(sequence);
	sequence = layer_sequence_create(layer, x, y, _new_sequence);
	
}

function match_sequence_to_facing_direction() {
	
	xscale = x_scale_factor * facing_direction;
	yscale = y_scale_factor;
	layer_sequence_xscale(sequence, xscale);
	layer_sequence_yscale(sequence, yscale);
	
	layer_sequence_x(sequence, x);
	layer_sequence_y(sequence, y);
	
}


// Interactions
function update_iframes() {
	iframes--;
	iframes = clamp(iframes, 0, 100);
}


