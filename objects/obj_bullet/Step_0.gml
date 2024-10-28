leave_trail(c_white, spr_trail_circle);

// Collision
if (position_meeting(x, y, obj_wall)) {
	instance_destroy(self);
}