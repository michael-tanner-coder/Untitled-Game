/// @function                   screenshake(_time, _magnitude, _fade);
/// @param  {real}  _time       The length of time - in steps - to shake the screen
/// @param  {real}  _magnitude  The amount of screenshake to apply
/// @param  {real}  _fade       How quickly the screenshake effect will fade out
/// @description    Set the screenshake object variables.

function screenshake(_time, _magnitude, _fade) {
	
	with (obj_camera_effects)
	{
	    shake = true;
	    shake_time = _time;
	    shake_magnitude = _magnitude;
	    shake_fade = _fade;
	}
	
}

function parallax() {
	var _camera_x  = camera_get_view_x(VIEW);
	var _camera_y  = camera_get_view_y(VIEW);
	
	layer_x("BackgroundFront", lerp(0, _camera_x, 0.5));
	layer_x("BackgroundMid", lerp(0, _camera_x, 0.7));
	layer_x("BackgroundBack", lerp(0, _camera_x, 0.85));

	layer_y("BackgroundFront", lerp(0, _camera_y, 0.5));
	layer_y("BackgroundMid", lerp(0, _camera_y, 0.7));
	layer_y("BackgroundBack", lerp(0, _camera_y, 0.85));
}