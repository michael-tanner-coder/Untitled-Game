if (owner) {
	x = owner.x;
	y = owner.y;
}

with(obj_actor) {
	if (array_contains(global.enemy_list, object_index)) {
		if (distance_to_object(other) <= other.radius) {
			speed_factor = 0.5;
		}
		else {
			speed_factor = 1;
		}
	}
}
