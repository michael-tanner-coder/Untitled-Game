shake = false;
shake_time = 0;
shake_magnitude = 0;
shake_fade = 0.25;
view_enabled=true;
view_visible[0] = true;
x = 0;
y = 0;

function start_screenshake(_shake_params = {}) {
	
	show_debug_message("-- initiating screenshake --");
	
	var _time = struct_get(_shake_params, "time");
	var _magnitude = struct_get(_shake_params, "magnitude");
	var _fade = struct_get(_shake_params, "fade");
	
	show_debug_message("Time: " + string(_time));
	show_debug_message("Magnitude: " + string(_magnitude));
	show_debug_message("Fade: " + string(_fade));
	
	if (_time == undefined || _magnitude == undefined || _fade == undefined) {
		show_debug_message("Error: One or more screenshake parameters are undefined");
		return;
	}
	
	screenshake(_time, _magnitude, _fade);
	
}

subscribe(id, SCREENSHAKED, start_screenshake);
subscribe(id, PLAYER_STOMPED, start_screenshake);