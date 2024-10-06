states_array[state].active_behavior();

if (score > global.best_score) {
	global.best_score = score;
}

if (!global.unlock_modal_open && lives < 1 && input_check_pressed("select")) {
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