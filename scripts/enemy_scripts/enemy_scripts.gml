function standard_enemy_create_event() {
    // Base properties
    xspd = 0;
    yspd = 0;
    base_speed = 5;
    hit = false;
    hit_timer = 0;
    max_dash_timer = 120;
    dash_timer = 0;
    point_value = 100;
    x_force = 0;
    y_force = 0;
    shield_sprite = spr_shield;
    movement_magnitude = 10;
    base_stun_time = 80;
    
    // Animation properties
    anim_start = 0;
    anim_current = 0;
    anim_end = 0;
    anim_length = 8;
    base_anim_speed = 8;
    anim_speed = base_anim_speed;
    x_frame = 0;
    y_frame = 0;
    x_offset = 32;
    y_offset = 32;
    frame_width = 32;
    frame_height = 32;
    rolling_spritesheet = spr_basic_enemy_sheet;
    hit_spritesheet = spr_hit_enemy_sheet;
    image_xscale = 2;
    image_yscale = 2;
    
    // State Machine
    fsm = new SnowState("active");
    
    fsm.add("active", {
    	step: function() {
			standard_enemy_step_event();    		
    	},
    	draw: function() {
    		standard_enemy_draw_event();
    	},
    });
    
    fsm.add("idle", {
    	step: function() {},
    	draw: function() {
    		standard_enemy_draw_event();
    	},
    });

    // Event Subscriptions
    subscribe(id, ACTORS_DEACTIVATED, function() {fsm.change("idle")});
    subscribe(id, ACTORS_ACTIVATED, function() {fsm.change("active")});
}

function standard_enemy_step_event() {
	// Settings
	var _game_speed = get_global_game_speed();
			
	// Follow player if we're not hit
	var _target = undefined;
	
	with(obj_player) {
	    _target = self;
	}
	
	if (_target && !hit) {
		show_debug_message("FOUND TARGET");
	    var _target_direction = point_direction(x,y,_target.x, _target.y);
	    var _target_distance = distance_to_point(_target.x, _target.y);
	    
	    var _magnitude = movement_magnitude;
	    var _x_force, _y_force;
	    _x_force = lengthdir_x(5, _target_direction) * _magnitude * _game_speed;
	    _y_force = lengthdir_y(5, _target_direction) * _magnitude * _game_speed;
	    
	    physics_apply_force(x, y, _x_force, _y_force);
	    
		x_force = _x_force;
		y_force = _y_force;
	    
		phy_rotation = -1 * _target_direction;
	}
	
	// If we're hit by a bullet, count down until recovery
	hit_timer -= 1 * _game_speed;
	hit_timer = max(0, hit_timer);
	if (hit_timer <= 0) {
	    hit = false;
	}
	
	// Update sprite
	if (hit) {
		x_force = 0;
		y_force = 0;
	}
}

function standard_enemy_draw_event() {
	draw_8_direction_movement(hit ? hit_spritesheet : rolling_spritesheet, frame_width, frame_height, anim_length, image_alpha, image_blend, x_offset, y_offset);
	draw_set_color(BLUE);
	if (global.debug) {
		draw_set_color(BLUE);
		physics_draw_debug();
	}
}

function standard_enemy_destroy_event() {
	// don't destroy enemies if we have gotten a game over 
    if (lives < 1) {
	    return;
    }
    
    if (hit) {
    	score += point_value;
    	var _score_text = instance_create_layer(x,y,layer, obj_float_text);
    	_score_text.text = "+" + string(round(point_value));
    	play_sound(snd_points, false);
    	with(obj_ui) {
    		shake_text(1, round(other.point_value/100), 0.5);
    	}
    	
    	spawn_particles(part_death, x, y);
    }
    
    publish(ENEMY_DEFEATED, point_value);
    
    unsubscribe_all(id);
}

function standard_enemy_bullet_collision() {
    var _game_speed = get_global_game_speed();
	
    // Track hit state for scoring
    if (!hit) {
    	spawn_particles(part_shoot, x, y);
    }
    hit = true;
    hit_timer = base_stun_time;
    
    // Force
    var _collision_direction = point_direction(x,y,other.x, other.y);
    var _push_direction = _collision_direction + 180;
    var _other_direction = point_direction(x,y,other.x, other.y);
    
    var _x_force, _y_force;
    _x_force = lengthdir_x(5, _other_direction + 180) * 10 * _game_speed;
    _y_force = lengthdir_y(5, _other_direction + 180) * 10 * _game_speed;
    
    // Destroy bullet
    instance_destroy(other);
}