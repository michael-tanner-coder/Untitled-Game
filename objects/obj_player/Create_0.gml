// Base Player Properties
x_force = 0;
y_force = 0;
recoil = global.settings.player_recoil;
max_speed = global.settings.player_speed;
base_speed = max_speed;
shot_timer = 0;
dash_timer = 0;
first_shot = false;
started_shooting = false;

// Upgrade properties
upgrade_stats = {
	player_density: global.settings.player_density,
	player_restitution: global.settings.player_restitution,
	player_linear_damping: global.settings.player_linear_damping,
	player_angular_damping: global.settings.player_angular_damping,
	player_friction: global.settings.player_friction,
	player_recoil: global.settings.player_recoil,
	player_lives: global.settings.player_lives,
	player_shot_count: global.settings.player_shot_count,
	player_bullet_force: global.settings.player_bullet_force,
};

// Tutorial Variables
global.moved = false;
global.shot = false;
global.dashed = false;

// Base Game Variables
lives = 1;
score = 0;

// Shadow
var _shadow = instance_create_layer(x,y,layer,obj_shadow);
_shadow.depth = depth + 1;
_shadow.owner = self;

// Physics Fixture
fix = physics_fixture_create();
physics_fixture_set_circle_shape(fix, 15);
physics_fixture_set_density(fix, upgrade_stats.player_density);
physics_fixture_set_collision_group(fix, 2);
physics_fixture_set_restitution(fix, upgrade_stats.player_restitution);
physics_fixture_set_linear_damping(fix, upgrade_stats.player_linear_damping);
physics_fixture_set_angular_damping(fix, upgrade_stats.player_angular_damping);
physics_fixture_set_friction(fix, upgrade_stats.player_friction);
my_fixture = physics_fixture_bind(fix, self);

// State Machine
fsm = new SnowState("active");

fsm.add("active", {
	step: function() {
		
		// --- Settings ---
		var _game_speed = global.settings.game_speed;
		
		// --- Inputs ---
		var _left = keyboard_check(ord("A")) * -1;
		var _right = keyboard_check(ord("D"));
		var _up = keyboard_check(ord("W")) * -1;
		var _down = keyboard_check(ord("S"));
		var _dash = keyboard_check_pressed(vk_space) || mouse_check_button_pressed(mb_right);
		var _clicked = mouse_check_button(mb_left);
		var _click_pressed = mouse_check_button_pressed(mb_left);
		var _click_released = mouse_check_button_released(mb_left);
		
		// --- Movement ---
		// get base force from user input
		x_force = base_speed * (_left + _right) * _game_speed;
		y_force = base_speed * (_up + _down) * _game_speed;

		// slow down when turning / moving diagnoally
		if (x_force != 0 && y_force != 0) {
			x_force *= 0.75;
			y_force *= 0.75;
		}

		// track when the player first moves for the tutorial display
		if (x_force != 0 || y_force != 0) {
			global.moved = true;
		}

		// get base force from user input
		physics_apply_impulse(x,y, x_force, y_force);


		// --- Shooting ---
		if (_click_pressed) {
			first_shot = true;	
			started_shooting = true;
		}

		if (started_shooting && _clicked && shot_timer == 0) {
			global.shot = true;
	
   
		    var _shoot_direction = point_direction(x,y,mouse_x, mouse_y);
			var _bullet = instance_create_layer(x +lengthdir_x(10, _shoot_direction)*2,y +lengthdir_y(10, _shoot_direction)*2, layer, obj_bullet);
    
		    // Bullet force
		    var _x_force, _y_force;
		    _x_force = lengthdir_x(10, _shoot_direction) * 10 * _game_speed;
		    _y_force = lengthdir_y(10, _shoot_direction) * 10 * _game_speed;
    
		    with(_bullet) {
		        physics_apply_impulse(x,y,_x_force, _y_force);
		    }
    
		    // Recoil force
		    var _base_recoil = first_shot ? recoil * 2 : recoil;
			var _x_recoil_force, _y_recoil_force;
		    _x_recoil_force = lengthdir_x(1, _shoot_direction + 180) * _base_recoil;
		    _y_recoil_force = lengthdir_y(1, _shoot_direction + 180) * _base_recoil;
		    physics_apply_impulse(x, y, _x_recoil_force, _y_recoil_force);
		    first_shot = false;
    
		    // Delay between shots
		    shot_timer = 10;
    
		    // Slow down player while firing
		    base_speed = 1;
    
		    // Enlarge sprite for pulse animation
		    image_xscale = 1.2;
		    image_yscale = 1.2;
	
			// Sound Feedback
			play_sound(snd_shoot, false);

		}

		if (_click_released) {
			first_shot = false;
			started_shooting = false;
		}

		// reset speed when not firing
		if (!_clicked) {
		    base_speed = max_speed * _game_speed;
		}

		// countdown until we can make another shot
		shot_timer--;
		shot_timer = max(0, shot_timer);

		// --- Dashing ---
		if (_dash && dash_timer == 0) {
		    dash_timer = 60;
	
		    global.dashed = true;
		}

		if (dash_timer > 0) {
		    base_speed = 2 * max_speed * _game_speed;
			leave_trail();
		}

		dash_timer--;
		dash_timer = max(0, dash_timer);


		// --- Visuals ---
		// scale back to normal for pulse animation
		image_xscale = lerp(image_xscale, 1, 0.3);
		image_yscale = lerp(image_yscale, 1, 0.3);

		phy_rotation = -1 * point_direction(x, y, mouse_x, mouse_y);

		// remove tutorial prompts when the player has moved and shot for the first time
		if (global.moved && global.shot && global.dashed && alarm_get(0) == -1) {
			alarm_set(0, 60);
		}

		// --- Collision ---
		if (position_meeting(x, y, obj_wall)) {
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
subscribe(id, UPGRADE_SELECTED, function(upgrade = {}) {
	var _effects = struct_get(upgrade, "effects");
	
	if (is_array(_effects)) {
		FOREACH _effects ELEMENT
			var _effect = _elem;
			switch (_effect.operation) 
			{
				case OPERATIONS.SET:
					upgrade_stats[$ _effect.property] = _effect.value;
					break;
				case OPERATIONS.ADD:
					upgrade_stats[$ _effect.property] += _effect.value;
					break;
				case OPERATIONS.SUBTRACT:
					upgrade_stats[$ _effect.property] -= _effect.value;
					break;
				case OPERATIONS.MULTIPLY:
					upgrade_stats[$ _effect.property] *= _effect.value;
					break;
				case OPERATIONS.DIVIDE:
					upgrade_stats[$ _effect.property] /= _effect.value;
					break;
				default:
					break;
			}
			
			physics_remove_fixture(self, my_fixture);
			physics_fixture_delete(fix);
			fix = physics_fixture_create();
			physics_fixture_set_circle_shape(fix, 15);
			physics_fixture_set_density(fix, upgrade_stats.player_density);
			physics_fixture_set_collision_group(fix, 2);
			physics_fixture_set_restitution(fix, upgrade_stats.player_restitution);
			physics_fixture_set_linear_damping(fix, upgrade_stats.player_linear_damping);
			physics_fixture_set_angular_damping(fix, upgrade_stats.player_angular_damping);
			physics_fixture_set_friction(fix, upgrade_stats.player_friction);
			my_fixture = physics_fixture_bind(fix, self);
			
		END
	}
})