x_buffer = 64;
starting_x = -1 * x_buffer;
transition_x = starting_x;
transition_y = 0;
target_x = -1 * x_buffer;

animation_progress = 0;
animation_speed = 0.02;
animation = WipeTransition;

// State Machine
fsm = new SnowState("inactive");

fsm.add("inactive", {
    enter: function() {},
    step: function() {},
    draw: function() {
        draw_animation(transition_x, transition_y);
    },
});

fsm.add("active", {
    enter: function() {},
    step: function() {
        animate(target_x);
    },
    draw: function() {
        draw_animation(transition_x, transition_y);
    },
});

// Methods
animate = function(_target_x) {
    var _curveStruct = animcurve_get(animation);
	var _channel = animcurve_get_channel(_curveStruct, "x");
	var _value = animcurve_channel_evaluate(_channel, animation_progress)
	
	var _distance = (_target_x - starting_x);
	transition_x = starting_x + (_distance * _value);
	
	animation_progress += animation_speed;
	animation_progress = clamp(animation_progress, 0, 1);
}

draw_animation = function(_x, _y) {
    draw_sprite(sprite_index, 0, _x, _y);
}

start_animation = function() {
    fsm.change("active");
}

stop_animation = function() {
    fsm.change("inactive");
}

reset_animation = function() {
    animation_progress = 0;
    transition_x = starting_x;
}