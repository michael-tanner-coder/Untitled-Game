// Spawn type properties
spawn_type = obj_dot;
spawn_height = 32;
shadow_sprite = spr_shadow;
sprite_index = spr_falling_slime;
image_xscale = 2;
image_yscale = 2;

// Animation properties
animation = FallingBounce;
starting_y = -1 * spawn_height; // original y position from before we start animating (start outside the top of the frame)
target_y = 0; // destination y position when animating
resting_y = y; // default y position when not animating
animation_progress = 0;
animation_speed = 0.015;

// Shadow to spawn
shadow = undefined;

// State Machine
fsm = new SnowState("animating");

fsm.add("animating", {
	enter: function() {
		animation_progress = 0;
		shadow = instance_create_layer(x, target_y + spawn_height/2, layer, obj_shadow);
		shadow.owner = self;
		shadow.follow_owner = false;
		shadow.depth = depth + 1;
		shadow.sprite_index = shadow_sprite;
	},
	step: function() {
		// update shadow properties
		shadow.y = target_y + spawn_height/2;
		shadow.sprite_index = shadow_sprite;
		
		// drop animation
		var _curveStruct = animcurve_get(animation);
		var _channel = animcurve_get_channel(_curveStruct, "y");
		var _value = animcurve_channel_evaluate(_channel, animation_progress)
		
		var _distance = (target_y - starting_y);
		y = starting_y + (_distance * _value);
		
		animation_progress += animation_speed;
		animation_progress = clamp(animation_progress, 0, 1);
		
		// enable the card for selection when animation is finished
		if (animation_progress >= 1) {
			fsm.change("destroying");
		}
	},
	draw: function() {
	    draw_self();
	}
});

fsm.add("destroying", {
    enter: function(){
        instance_destroy(shadow);
        instance_create_layer(x, y, layer, spawn_type);
        instance_destroy(self);
    },
    step: function(){},
    draw: function(){},
});
