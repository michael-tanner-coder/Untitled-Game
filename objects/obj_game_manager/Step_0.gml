states_array[state].active_behavior();

if (score > global.best_score) {
	global.best_score = score;
}

if (lives < 1 && keyboard_check_pressed(vk_space)) {
	room_restart();
}

if (struct_get(global.settings, "window_mode")) {
	if (global.settings.window_mode == "Windowed") {
		window_set_fullscreen(false);
	}
	else {
		window_set_fullscreen(true);
	}
}