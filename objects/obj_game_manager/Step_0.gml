states_array[state].active_behavior();

if (room == rm_main_menu) {
	window_set_cursor(cr_default);
	cursor_sprite = -1;
}
else {
	cursor_sprite = spr_reticle;
	window_set_cursor(cr_none);
}

if (score > global.best_score) {
	global.best_score = score;
}

if (struct_get(global.settings, "window_mode")) {
	if (global.settings.window_mode == "Windowed") {
		window_set_fullscreen(false);
	}
	else {
		window_set_fullscreen(true);
	}
}

if (keyboard_check_pressed(ord("R"))) {
	reset_unlocks();
}