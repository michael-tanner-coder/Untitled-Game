// BASE ACTOR PROPERTIES

// Jump properties
jump_buffer_time = 0;
max_jump_buffer_time = 24;
jump_count = 0;
coyote_time = 0;
max_coyote_time = 8;
max_jump_count = 1;
jump_hold_frames = 10;
jump_speed = 1;
jump_timer = 0;

// Physics properties
xspd = 0;
yspd = 0;
prev_xspd = 0;
prev_yspd = 0;
original_xspd = xspd;
original_yspd = yspd;
move_speed = 1;
fall_speed = 1;
actor_gravity = 0.25;
min_fall_speed = 0.875;
max_fall_speed = 1;
xforce = 0;
yforce = 0;
force_friction = 0.95;
speed_factor = 1;

// Damage properties
iframes = 0;
screenwrap_iframes = 24;
bonus_iframes = 0;

// Attack properties
time_between_shots = 300;

// Interaction properties
touching_ground = false;
touching_ground_last_frame = false;
touching_wall = false;
can_destroy_blocks_below = false;
can_destroy_blocks_above = false;
can_bounce = false;
can_push_blocks = false;
can_ground_pound = false;
ground_pound_active = false;
heavy = false;
can_screenwrap = true;
is_screenwrapping = false;
bounced = false;
lethal = false;
flipped = false;
can_flip = false;
flip_time = 60;
max_time_until_unflip = 480;
time_until_unflip = max_time_until_unflip;
warping_enabled = true;
touching_warp_beam = false;
invincible = false;
protected_above = false;
protected_below = false;
exploding = false;

// Animation Properties
xscale = 1;
yscale = 1;
xoffset = 0;
yoffset = 0;
use_sprites = false;
facing_direction = 1;
x_scale_factor = 1;
y_scale_factor = 1;
sequence = undefined;

// Score Properties
base_points = 100;

// STATE MACHINE
states_array = [];
state = ACTOR_STATE.IDLE;
previous_state = ACTOR_STATE.IDLE;

idle_behavior = function() {}

moving_behavior = function() {}

hurt_behavior = function() {}

// State Behaviors
states_array[ACTOR_STATE.IDLE] = {
    entrance_behavior: function() {
        show_debug_message("enter idle state");
    },
    active_behavior: idle_behavior,
    exit_behavior: function() {
        show_debug_message("exit idle state");
    },
};

states_array[ACTOR_STATE.MOVING] = {
    entrance_behavior: function() {
        show_debug_message("enter moving state");
    },
    active_behavior: moving_behavior,
    exit_behavior: function() {
        show_debug_message("exit moving state");
    },
};

states_array[ACTOR_STATE.HURT] = {
    entrance_behavior: function() {
		show_debug_message("enter hurt state");
	},
    active_behavior: hurt_behavior,
    exit_behavior: function() {
		show_debug_message("exit hurt state");
	},
};

states_array[ACTOR_STATE.INACTIVE] = {
    entrance_behavior: function() {
		show_debug_message("enter inactive state");
	},
    active_behavior: function() {},
    exit_behavior: function() {
		show_debug_message("exit inactive state");
	},
};

// event subscriptions
subscribe(id, "end_level", function() {
	show_debug_message("DEACTIVATING ACTOR");
	change_state(ACTOR_STATE.INACTIVE);
});

subscribe(id, "deactivate_all_actors", function() {
	show_debug_message("DEACTIVATING ACTOR");
	change_state(ACTOR_STATE.INACTIVE); 
});

subscribe(id, "activate_all_actors", function() {
	show_debug_message("ACTIVATING ACTOR");
	change_state(ACTOR_STATE.MOVING); 
});