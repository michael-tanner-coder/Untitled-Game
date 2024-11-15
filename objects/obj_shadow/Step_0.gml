if (follow_owner) {
	x = owner.x + offset_x;
	y = owner.y + offset_y;
}

if (!instance_exists(owner)) {
	instance_destroy(self);
}