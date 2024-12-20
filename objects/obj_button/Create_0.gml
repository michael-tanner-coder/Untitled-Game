// Base Styles
width = 150;
height = 60;
color = BLUE;
sprite = spr_button_normal;

// Button Content
text = "Lorem ipsum type shit";
text_font = fnt_small;
text_padding = 5;

// Events
on_click_event = "";
event_payload = {};

// State Information
highlighted = false;
time_until_active = 120;
static_button = false;
disabled = true;
selected = false;

// Animation
starting_y = y; // original y position from before we start animating
target_y = 0; // destination y position when animating
resting_y = y; // default y position when not animating
animation_progress = 0;
animation_speed = 0.02;
animation = EaseOutElastic;

// State Machine
fsm = new SnowState("active");

fsm.add("animating", {
	enter: function() {
		animation_progress = 0;
	},
	step: function() {
		// card animation
		var _curveStruct = animcurve_get(animation);
		var _channel = animcurve_get_channel(_curveStruct, "y");
		var _value = animcurve_channel_evaluate(_channel, animation_progress)
		
		var _distance = (target_y - starting_y);
		y = starting_y + (_distance * _value);
		
		animation_progress += animation_speed;
		animation_progress = clamp(animation_progress, 0, 1);
		
		// enable the card for selection when animation is finished
		if (animation_progress >= 1) {
			fsm.change("active");
		}
	}
});

fsm.add("inactive", {
	step: function() {
		if (static_button) {
			return;
		}
		
		time_until_active--;
		if (time_until_active <= 0) {
			fsm.change("active");
		}
	}
});

fsm.add("active", {
	enter: function() {},
	step: function() {
		// Disabled buttons are faded and can't be selected
		if (disabled) {
			image_alpha = 0.5;
			return;
		}
		else {
			image_alpha = 1;
		}
	
		// Select card
		if (highlighted && mouse_check_button_pressed(mb_left)) {
			publish(on_click_event);
		}
	}
});