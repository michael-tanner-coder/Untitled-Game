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

// Animation
anim_start = 0;
anim_current = 0;
anim_end = 0;
anim_length = 8;
base_anim_speed = 2;
anim_speed = base_anim_speed;
x_frame = 0;
y_frame = 0;
x_offset = 0;
y_offset = 0;
frame_width = 24;
frame_height = 27;

// Shadow
var _shadow = instance_create_layer(x,y,layer,obj_shadow);
_shadow.depth = depth + 1;
_shadow.owner = self;

// State Machine
fsm = new SnowState("active");

fsm.add("active", {
	step: function() {
		
		// Settings
		var _game_speed = global.settings.game_speed;
				
		// Follow player if we're not hit
		var _target = undefined;
		
		with(obj_player) {
		    _target = self;
		}
		
		if (_target && !hit) {
			show_debug_message("FOUND TARGET");
		    var _target_direction = point_direction(x,y,_target.x, _target.y);
		    var _target_distance = distance_to_point(_target.x, _target.y);
		    
		    var _magnitude = 10;
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
			sprite_index = spr_dot_hit;
			x_force = 0;
			y_force = 0;
		}
		else {
		    sprite_index = spr_dot;
		}
	},
	draw: function() {
		draw_8_direction_movement(spr_basic_enemy_sheet, frame_width, frame_height, anim_length);
	},
});
fsm.add("idle", {
	step: function() {},
	draw: function() {
		draw_self();
	},
});

// Event Subscriptions
subscribe(id, ACTORS_DEACTIVATED, function() {fsm.change("idle")});
subscribe(id, ACTORS_ACTIVATED, function() {fsm.change("active")});
