leave_trail();

// Collision
if (position_meeting(x, y, obj_wall)) {
	instance_destroy(self);
}