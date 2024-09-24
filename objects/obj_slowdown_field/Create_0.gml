owner = undefined;
radius = 128;
subscribe(id, DEACTIVATED_POWERUP, function() {
	instance_destroy(self);
});