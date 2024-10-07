xspd = 0;
yspd = 0;
base_speed = 5;
hit = false;
hit_timer = 0;
growth_rate = 0.25;
max_scale = 4;
point_value = 100;
x_force = 0;
y_force = 0;
shield_sprite = spr_shield;

// Physics fixture
fix = physics_fixture_create();
physics_fixture_set_circle_shape(fix, 16);
physics_fixture_set_density(fix, 0.5);
physics_fixture_set_collision_group(fix, 1);
physics_fixture_set_restitution(fix, 0.875);
physics_fixture_set_linear_damping(fix, 0.1);
physics_fixture_set_angular_damping(fix, 0.1);
physics_fixture_set_friction(fix, 0.4);
my_fixture = physics_fixture_bind(fix, self);

// Shadow
shadow = instance_create_layer(x,y,layer,obj_shadow);
shadow.depth = depth + 1;
shadow.owner = self;

// State Machine
fsm = new SnowState("active");

fsm.add("active", {
	step: function() {
		var _game_speed = global.settings.game_speed;
		
		// Follow player if we're not hit
		var _target = undefined;
		
		with(obj_player) {
		    _target = self;
		}
		
		if (_target && !hit) {
		    var _target_direction = point_direction(x,y,_target.x, _target.y);
		    var _target_distance = distance_to_point(_target.x, _target.y);
		    
		    var _magnitude = 10;
		    var _x_force, _y_force;
		    _x_force = lengthdir_x(5, _target_direction) * _magnitude * _game_speed;
		    _y_force = lengthdir_y(5, _target_direction) * _magnitude * _game_speed;
		    
		    physics_apply_force(x, y, _x_force, _y_force);
		    
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
		}
		else {
		    sprite_index = spr_exploding_dot;
		}
		
		// Collision
		if (position_meeting(x, y, obj_wall)) {
			instance_destroy(self);
		}
		
		// increase size over time
		if (image_xscale < max_scale && image_yscale < max_scale) {
			// Sprite change
			var _dt = delta_time / 1000000;
			image_xscale += _dt * growth_rate;
			image_yscale += _dt * growth_rate;
			shadow.image_xscale = image_xscale;
			shadow.image_yscale = image_yscale;
			
			// Physics update
			physics_remove_fixture(self, my_fixture);
			physics_fixture_delete(fix);
			fix = physics_fixture_create();
			physics_fixture_set_circle_shape(fix, 16 * image_xscale);
			physics_fixture_set_density(fix, 0.5 * image_xscale);
			physics_fixture_set_collision_group(fix, 1);
			physics_fixture_set_restitution(fix, 0.875);
			physics_fixture_set_linear_damping(fix, 0.1);
			physics_fixture_set_angular_damping(fix, 0.1);
			physics_fixture_set_friction(fix, 0.4);
			my_fixture = physics_fixture_bind(fix, self);
			point_value = image_xscale * 200;
		}
		
		if (image_xscale >= max_scale) {
			instance_destroy(self);
		}
	},
});
fsm.add("idle", {
	step: function() {},
});

// Event Subscriptions
subscribe(id, ACTORS_DEACTIVATED, function() {fsm.change("idle")});
subscribe(id, ACTORS_ACTIVATED, function() {fsm.change("active")});