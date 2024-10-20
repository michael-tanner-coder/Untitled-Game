// Goals:
// 1. Fix UI display + resolution bugs
// -- dash sprite
// -- resize characters (50% larger)

// 2. Build level select menu
// 3. Build character select menu

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
i_frames = 0;
respawn_i_frames = 120;
base_fixture_size = 15;
available_bombs = 1;
global.currency = 0;

// Upgrade properties
upgrade_stats = {
	player_density: global.settings.player_density,
	player_restitution: global.settings.player_restitution,
	player_linear_damping: global.settings.player_linear_damping,
	player_angular_damping: global.settings.player_angular_damping,
	player_friction: global.settings.player_friction,
	player_recoil: global.settings.player_recoil,
	player_lives: global.settings.player_lives + 1,
	player_shot_count: global.settings.player_shot_count + 1,
	player_bullet_force: global.settings.player_bullet_force,
	player_firing_rate: global.settings.player_firing_rate,
	player_shot_spread_angle: global.settings.player_shot_spread_angle,
	player_size: global.settings.player_size,
	player_alt_fire: global.settings.player_alt_fire,
};

// Tutorial Variables
global.moved = false;
global.shot = false;
global.dashed = false;

// Base Game Variables
lives = 1;
score = 0;

// Shadow
shadow = instance_create_layer(x,y,layer,obj_shadow);
shadow.depth = depth + 1;
shadow.owner = self;

// Physics Fixture
fix = physics_fixture_create();
physics_fixture_set_circle_shape(fix, base_fixture_size * upgrade_stats.player_size);
physics_fixture_set_density(fix, upgrade_stats.player_density);
physics_fixture_set_collision_group(fix, 2);
physics_fixture_set_restitution(fix, upgrade_stats.player_restitution);
physics_fixture_set_linear_damping(fix, upgrade_stats.player_linear_damping);
physics_fixture_set_angular_damping(fix, upgrade_stats.player_angular_damping);
physics_fixture_set_friction(fix, upgrade_stats.player_friction);
my_fixture = physics_fixture_bind(fix, self);

// Sizing
target_size = upgrade_stats.player_size;
image_xscale = target_size;
image_yscale = target_size;

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
		var _alt = mouse_check_button_pressed(mb_right);
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
   
			var _shot_spread_angle = upgrade_stats.player_shot_spread_angle;
			var _shot_spread_count = upgrade_stats.player_shot_count;
			var _shoot_direction = point_direction(x,y,mouse_x, mouse_y);
			
			for (var _i = 0; _i < _shot_spread_count; _i++) {
				var _bullet_angle = _shoot_direction + (_i * _shot_spread_angle) - ((_shot_spread_count - 1) * (_shot_spread_angle/2));
				
				var _bullet = instance_create_layer(x +lengthdir_x(10, _shoot_direction)*2,y +lengthdir_y(10, _shoot_direction)*2, layer, obj_bullet);
	    
			    // Bullet force
			    var _x_force, _y_force;
			    _x_force = lengthdir_x(10, _bullet_angle) * upgrade_stats.player_bullet_force * _game_speed;
			    _y_force = lengthdir_y(10, _bullet_angle) * upgrade_stats.player_bullet_force * _game_speed;
	    
			    with(_bullet) {
			        physics_apply_impulse(x,y,_x_force, _y_force);
			    }
			}
    
		    // Recoil force
		    var _base_recoil = first_shot ? recoil * 2 : recoil;
			var _x_recoil_force, _y_recoil_force;
		    _x_recoil_force = lengthdir_x(1, _shoot_direction + 180) * _base_recoil;
		    _y_recoil_force = lengthdir_y(1, _shoot_direction + 180) * _base_recoil;
		    physics_apply_impulse(x, y, _x_recoil_force, _y_recoil_force);
		    first_shot = false;
    
		    // Delay between shots
		    shot_timer = upgrade_stats.player_firing_rate;
    
		    // Slow down player while firing
		    base_speed = 1;
    
		    // Enlarge sprite for pulse animation
		    image_xscale = target_size * 1.2;
		    image_yscale = target_size * 1.2;
	
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
		shot_timer -= 1 * global.settings.game_speed;
		shot_timer = max(0, shot_timer);

		// --- Dashing ---
		if (upgrade_stats.player_alt_fire == ABILITIES.DASH && _alt && dash_timer == 0) {
		    dash_timer = 60;
		    global.dashed = true;
		}

		if (dash_timer > 0) {
		    base_speed = 2 * max_speed * _game_speed;
		}

		dash_timer--;
		dash_timer = max(0, dash_timer);
		
		// --- Bombs ---
		if (_alt && upgrade_stats.player_alt_fire == ABILITIES.BOMB && available_bombs > 0) {
			available_bombs--;
			instance_create_layer(x, y, layer, obj_bomb);
			show_debug_message("PLANTING BOMB");
		}
		
		if (instance_number(obj_bomb) < 1) {
			available_bombs = 1;
		}

		// --- Visuals ---
		// scale back to normal for pulse animation
		image_xscale = lerp(image_xscale, target_size, 0.3);
		image_yscale = lerp(image_yscale, target_size, 0.3);

		// remove tutorial prompts when the player has moved and shot for the first time
		if (global.moved && global.shot && global.dashed && alarm_get(0) == -1) {
			alarm_set(0, 60);
		}

		// --- Collision ---
		if (position_meeting(x, y, obj_wall)) {
			instance_destroy(self);
		}
		
		// -- Invincibility Frames
		if (i_frames > 0) {
			i_frames--;
		}
		i_frames = clamp(i_frames, 0, respawn_i_frames);
	},
	draw: function() {
		draw_8_direction_movement(dash_timer > 0 ? spr_player_sheet_dash : spr_player_sheet, frame_width, frame_height, anim_length, image_alpha, image_blend, frame_width/2, frame_height/2);
	},
});
fsm.add("idle", {
	step: function() {},
	draw: function() {
		draw_self();
	},
});

// Methods
lose_life = function() {
	// Don't lose life it we're invincible
	if (i_frames > 0) {
		return;
	}
	
	// VFX
	spawn_particles(part_death, x, y);
	audio_play_sound(snd_die, 1, false);
	screenshake(1, 6, 0.5);
	
	// Check for game over
	upgrade_stats.player_lives -= 1;
	lives = upgrade_stats.player_lives;
	if (upgrade_stats.player_lives <= 0) {
		instance_destroy(self);
		publish(LOST_LEVEL);
		return;
	}
	
	// Reposition to center of room on death
	phy_position_x = room_width/2;
	phy_position_y = room_height/2;
	x = room_width/2;
	y = room_height/2;
	
	// Make player invincible for a short time
	i_frames = respawn_i_frames;
}

// Event Subscriptions
subscribe(id, ACTORS_DEACTIVATED, function() {fsm.change("idle")});
subscribe(id, ACTORS_ACTIVATED, function() {fsm.change("active")});
subscribe(id, WON_LEVEL, function() {fsm.change("idle")});
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
			
			// Update Player Physics
			physics_remove_fixture(self, my_fixture);
			physics_fixture_delete(fix);
			fix = physics_fixture_create();
			physics_fixture_set_circle_shape(fix, base_fixture_size * upgrade_stats.player_size);
			physics_fixture_set_density(fix, upgrade_stats.player_density);
			physics_fixture_set_collision_group(fix, 2);
			physics_fixture_set_restitution(fix, upgrade_stats.player_restitution);
			physics_fixture_set_linear_damping(fix, upgrade_stats.player_linear_damping);
			physics_fixture_set_angular_damping(fix, upgrade_stats.player_angular_damping);
			physics_fixture_set_friction(fix, upgrade_stats.player_friction);
			my_fixture = physics_fixture_bind(fix, self);
			
			// Update Global Game Variables
			lives = upgrade_stats.player_lives;
			target_size = upgrade_stats.player_size;
			
			// Make the player temporarily invincible to give them time to readjust when returning to normal gameplay
			i_frames = respawn_i_frames;
			
		END
	}
});