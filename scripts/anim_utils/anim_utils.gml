function init_base_animation_properties(_starting_value = 0, _target_value = 1, _animation = EaseOutElastic, _animation_speed = 0.1) {
    starting_value = _starting_value; // original value from before we start animating
    target_value = _target_value; // destination value position when animating
    animation_progress = 0; // track our progress through the full animation (goes from 0 to 1)
    animation_speed = _animation_speed; // how much we increase animation_progress on every frame
    animation = _animation; // animation curve we follow to get our current animation value
    
    get_animation_value = function(_animation_property = "") {
    	var _curveStruct = animcurve_get(animation);
    	var _channel = animcurve_get_channel(_curveStruct, _animation_property);
    	var _value = animcurve_channel_evaluate(_channel, animation_progress)
    	
    	var _distance = (target_value - starting_value);
    	return starting_value + (_distance * _value);
    };
    
    progress_animation = function() {
        animation_progress += animation_speed;
		animation_progress = clamp(animation_progress, 0, 1);
    }
};