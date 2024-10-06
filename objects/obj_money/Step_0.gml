var _curveStruct = animcurve_get(animation);
var _channel = animcurve_get_channel(_curveStruct, "y");
var _value = animcurve_channel_evaluate(_channel, animation_progress)

var _distance = (target_y - starting_y);
display_y = starting_y + (_distance * _value);

animation_progress += animation_speed;
if (animation_progress > 1) {
    animation_progress = 0;
}
// animation_progress = clamp(animation_progress, 0, 1);