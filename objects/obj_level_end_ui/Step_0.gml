if (data_source == undefined || data_source == noone) {
    return;
}

// only respond to input for "Hold to Continue" when we have won or lost a level 
if (victory || game_over) {
	if (input_check_pressed("progress")) {
		skip_text_animation();
	}
	
	if (input_check("skip")) {
		hold_timer += (delta_time / 10000);
		hold_timer = clamp(hold_timer, 0, max_hold_timer);
	}
	
	if (input_check_released("skip")) {
		hold_timer = 0;
	}
	
	if (hold_timer >= max_hold_timer) {
		if (victory) {
			go_to_next_scene();
		}
		
		if (game_over && !data_source.is_tutorial_scene) {
			lose_game();
		}
		
		if (game_over && data_source.is_tutorial_scene) {
			reset_game_state();
			room_restart();
		}
	}
}