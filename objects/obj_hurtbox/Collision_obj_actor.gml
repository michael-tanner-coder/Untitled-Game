
if (array_contains(global.enemy_list, other.object_index) && other.lethal) {
	collided_with_lethal_actor = true;
	// destroy_enemy(other);
}

if (vulnerable && collided_with_lethal_actor && other.lethal) {
	publish(damage_event);
}