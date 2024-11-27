standard_enemy_destroy_event();

global.boss_lives -= 1;
if (global.boss_lives < 1) {
	publish(DEFEATED_BOSS);
} else {
	// spawn next life
	instance_create_layer(obj_boss_spawn_point.x, obj_boss_spawn_point.y, layer, object_index);
	screenshake(4, 10, 0.5);
}