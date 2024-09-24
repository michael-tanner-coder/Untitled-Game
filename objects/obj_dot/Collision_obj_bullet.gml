// Track hit state for scoring
if (!hit) {
	spawn_particles(part_shoot, x, y);
}

hit = true;
hit_timer = 80;

// Force
var _collision_direction = point_direction(x,y,other.x, other.y);
var _push_direction = _collision_direction + 180;
var _other_direction = point_direction(x,y,other.x, other.y);

var _x_force, _y_force;
_x_force = lengthdir_x(5, _other_direction + 180) * 10;
_y_force = lengthdir_y(5, _other_direction + 180) * 10;

// Destroy bullet
instance_destroy(other);