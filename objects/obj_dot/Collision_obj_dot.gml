if (hit && point_value >= other.point_value) {
	
	if (!hit) {
		var _sys = part_system_create();
		part_particles_burst(_sys, x, y, part_shoot);
	}
	
	other.hit = true;
	other.hit_timer = 80;
}