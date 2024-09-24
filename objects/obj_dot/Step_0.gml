
// Follow player if we're not hit
var _target = undefined;

with(obj_player) {
    _target = self;
}

if (_target && !hit) {
	show_debug_message("FOUND TARGET");
    var _target_direction = point_direction(x,y,_target.x, _target.y);
    var _target_distance = distance_to_point(_target.x, _target.y);
    
    var _magnitude = 10;
    var _x_force, _y_force;
    _x_force = lengthdir_x(5, _target_direction) * _magnitude;
    _y_force = lengthdir_y(5, _target_direction) * _magnitude;
    
    physics_apply_force(x, y, _x_force, _y_force);
    
	x_force = _x_force;
	y_force = _y_force;
    
	phy_rotation = -1 * _target_direction;
}


// If we're hit by a bullet, count down until recovery
hit_timer--;
hit_timer = max(0, hit_timer);
if (hit_timer <= 0) {
    hit = false;
}


// Update sprite
if (hit) {
	sprite_index = spr_dot_hit;
	x_force = 0;
	y_force = 0;
}
else {
    sprite_index = spr_dot;
}