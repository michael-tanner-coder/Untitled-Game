// Track hit state for scoring
if (!other.hit) {
	spawn_particles(part_shoot, other.x, other.y);
}

other.hit = true;
other.hit_timer = 80;