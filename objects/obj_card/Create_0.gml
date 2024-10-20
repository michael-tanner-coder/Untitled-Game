// Base Styles
width = 150;
height = 300;
color = BLUE;

// Card Content
header = "Card Header";
header_font = fnt_medium;
sprite = spr_white_circle;
description = "Lorem ipsum type shit";
description_font = fnt_small;
description_padding = 10;
price = 0;
upgrade = global.upgrades[0];

// State Information
highlighted = false;
time_until_active = 120;
static_card = false;

// Animation
starting_y = y; // original y position from before we start animating
target_y = 0; // destination y position when animating
resting_y = y; // default y position when not animating
animation_progress = 0;
animation_speed = 0.02;
animation = EaseOutElastic;

// State Machine
fsm = new SnowState("inactive");

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
		if (static_card) {
			return;
		}
		
		time_until_active--;
		if (time_until_active <= 0) {
			fsm.change("animating");
		}
	}
});

fsm.add("active", {
	enter: function() {
		target_y = resting_y - 75;
	},
	step: function() {
		if (highlighted) {
			y = lerp(y, target_y, 0.08);
		}
		else {
			y = lerp(y, resting_y, 0.08);
		}
	
		if (highlighted && mouse_check_button_pressed(mb_left) && global.currency >= price) {
			global.currency -= price;
			publish(UPGRADE_SELECTED, upgrade);
		}
		else {
			play_sound(snd_button_back_alt);
		}
	}
});