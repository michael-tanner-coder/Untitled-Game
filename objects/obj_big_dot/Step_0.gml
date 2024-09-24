var _game_speed = global.settings.game_speed;

// Follow player if we're not hit
var _target = undefined;

with(obj_player) {
    _target = self;
}

if (_target && !hit) {
    var _target_direction = point_direction(x,y,_target.x, _target.y);
    var _target_distance = distance_to_point(_target.x, _target.y);
    
    var _magnitude = 100;
    var _x_force, _y_force;
    _x_force = lengthdir_x(5, _target_direction) * _magnitude * _game_speed;
    _y_force = lengthdir_y(5, _target_direction) * _magnitude * _game_speed;
    
    physics_apply_force(x, y, _x_force, _y_force);
    
    phy_rotation = -1 * _target_direction;
}


// If we're hit by a bullet, count down until recovery
hit_timer -= 1 * _game_speed;
hit_timer = max(0, hit_timer);
if (hit_timer <= 0) {
    hit = false;
}


// Update sprite
if (hit) {
	sprite_index = spr_big_dot_hit;
}
else {
    sprite_index = spr_big_dot;
}

// Collision
if (position_meeting(x, y, obj_wall)) {
	instance_destroy(self);
}