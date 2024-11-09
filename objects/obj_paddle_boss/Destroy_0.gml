standard_enemy_destroy_event();
publish(DEFEATED_BOSS);
if (paddle != undefined) {
	instance_destroy(paddle);
}