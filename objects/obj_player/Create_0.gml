x_force = 0;
y_force = 0;
max_speed = 5;
base_speed = max_speed;
shot_timer = 0;
recoil = 23;
dash_timer = 0;
dash_meter = 0;
dash_meter_max = 120;
shot_delay_max = 30;
show_shot_delay_meter = false;
meter_width = 100;
meter_height = 20;
meter_color = PURPLE;
first_shot = false;
started_shooting = false;

global.moved = false;
global.shot = false;
global.dashed = false;

lives = 1;
score = 0;

var _shadow = instance_create_layer(x,y,layer,obj_shadow);
_shadow.depth = depth + 1;
_shadow.owner = self;

fsm = new SnowState("active");

fsm.add("active", {
	enter: function() {
		
	},
	step: function() {
		
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
		x_force = base_speed * (_left + _right);
		y_force = base_speed * (_up + _down);

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
		    _x_force = lengthdir_x(10, _shoot_direction) * 10;
		    _y_force = lengthdir_y(10, _shoot_direction) * 10;
    
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
		    base_speed = max_speed;
		}

		// countdown until we can make another shot
		shot_timer--;
		shot_timer = max(0, shot_timer);

		if (shot_timer <= 0) {
			show_shot_delay_meter = false;
		}

		// --- Dashing ---
		if (_dash && dash_timer == 0) {
		    dash_timer = 60;
	
		    global.dashed = true;
		}

		if (dash_timer > 0) {
		    base_speed = 2 * max_speed;
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