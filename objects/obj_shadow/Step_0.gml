x = owner.x;
y = owner.y;

if (!instance_exists(owner)) {
	instance_destroy(self);
}