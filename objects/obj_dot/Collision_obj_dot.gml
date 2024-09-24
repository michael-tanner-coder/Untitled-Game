if (hit && point_value >= other.point_value) {
	
	if (!hit) {
		spawn_particles(part_shoot, x, y);
	}
	
	other.hit = true;
	other.hit_timer = 80;
}