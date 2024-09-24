states_array[state].active_behavior();

if (score > global.best_score) {
	global.best_score = score;
}

if (lives < 1 && keyboard_check_pressed(vk_space)) {
	room_restart();
}

if (keyboard_check_pressed(vk_escape)) {
	window_set_fullscreen(!window_get_fullscreen())
}