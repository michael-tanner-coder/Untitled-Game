standard_enemy_destroy_event();

global.boss_lives -= 1;
if (global.boss_lives < 1) {
	publish(DEFEATED_BOSS);
} else {
	// spawn next life
	var _falling_spawn = instance_create_layer(obj_boss_spawn_point.x, -1*sprite_get_height(sprite_index), layer, obj_falling_spawn);
	_falling_spawn.spawn_type = obj_paddle_boss;
	_falling_spawn.target_y = obj_boss_spawn_point.x;
	_falling_spawn.spawn_height = sprite_get_height(sprite_index);
	_falling_spawn.shadow_sprite = spr_shadow_boss;
	_falling_spawn.sprite_index = sprite_index;
	screenshake(4, 10, 0.5);
}

if (paddle != undefined) {
	instance_destroy(paddle);
}