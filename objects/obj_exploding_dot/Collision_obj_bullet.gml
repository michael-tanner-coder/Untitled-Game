var _game_speed = global.settings.game_speed;

if (!hit) {
	spawn_particles(part_shoot, x, y);
}

// Track hit state for scoring
hit = true;
hit_timer = 80;

// Force
var _collision_direction = point_direction(x,y,other.x, other.y);
var _push_direction = _collision_direction + 180;
var _other_direction = point_direction(x,y,other.x, other.y);

var _x_force, _y_force;
_x_force = lengthdir_x(5, _other_direction + 180) * 10 * _game_speed;
_y_force = lengthdir_y(5, _other_direction + 180) * 10 * _game_speed;

// physics_apply_impulse(x, y, _x_force, _y_force);

// Destroy bullet
instance_destroy(other);