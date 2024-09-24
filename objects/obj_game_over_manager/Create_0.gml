fill_sprite = spr_progress_bar_fill;
outline_sprite = spr_progress_bar_outline;
outline_size = 6;
bar_margin = 20;
banner_x = -1000;

next_unlock = undefined;
progress_points = global.unlock_progress;
total_points = global.unlock_progress + score;
item_name = "";
item_data = undefined;

// TODO: add grid menu to view unlocked items of any category

fsm = new SnowState("countup");

fsm.add("countup", {
	enter: function() {
		next_unlock = get_next_unlock();
		item_name = "";
		play_sound(snd_time_counter, false);
	},
	step: function() {
		if (next_unlock == undefined) {
			fsm.change("idle");
			return;
		}
		
		var _target_points = min(total_points, next_unlock.required_points);
		progress_points = lerp(progress_points, _target_points, 0.1);
		progress_points = clamp(progress_points, 0, _target_points);
		if (abs(progress_points - _target_points) < 1) {
			progress_points = _target_points;
		}
	
		// skip progress bar animation
		if (input_check_pressed("select")) {
			progress_points = _target_points;
		}
		
		// move to unlock state if we cleared the point requirement for the next unlock
		if (is_numeric(next_unlock.required_points) && progress_points >= next_unlock.required_points) {
			fsm.change("unlock");
			return;
		}
		
		if (progress_points == total_points) {
			fsm.change("idle");
		}
	},
});

fsm.add("unlock", {
	enter: function() {
		unlock_next_item(progress_points);
	
		// get item data for display 
		item_data = get_unlock_item_data(next_unlock);
		item_name = item_data.name;
		
		// reset target points for next time we go to the countup state
		total_points -= progress_points;
		progress_points = 0;
		
		play_sound(snd_tutorial_success);
	},
	step: function() {
		if (input_check_pressed("select")) {
			fsm.change("countup");
		}
		
		banner_x = lerp(banner_x, 0, 0.2);
	},
	draw: function() {
		var _rect_x = banner_x;
		var _rect_y = 234;
		var _rect_width = room_width;
		var _rect_height = 284*2;
		
		// banner overlay
		draw_set_color(c_black);
		draw_set_alpha(0.75);
		draw_rectangle(_rect_x, _rect_y, _rect_x + _rect_width, _rect_y + _rect_height, false);
		draw_set_alpha(1);
		
		// header
		draw_outlined_text(_rect_x + _rect_width/2, _rect_y + 40, "NEW UNLOCK!", PINK, fnt_header, STANDARD_OUTLINE_DISTANCE, WHITE);
		
		// item name
		draw_outlined_text(_rect_x + _rect_width/2, _rect_y + 100, item_name, BLUE, fnt_header, STANDARD_OUTLINE_DISTANCE, WHITE);
		
		// item sprite
		var _sprite = struct_get(item_data, "sprite");
		if (_sprite != undefined) {
			draw_set_color(WHITE);
			draw_sprite_ext(spr_circle_fill, 0, _rect_x + _rect_width/2, _rect_y + _rect_height/2, 1, 1, 0, c_white, 1);
			draw_sprite_ext(_sprite, 0, _rect_x + _rect_width/2, _rect_y + _rect_height/2, 1, 1, 0, c_white, 1);
		}
		
		// shop notification
		if (next_unlock.category == "powerups") {
			draw_set_color(WHITE);
			draw_text(_rect_x + _rect_width/2, _rect_y + _rect_height - 50, "NOW AVAILABLE TO PURCHASE AT THE SHOP");
		}

		// hat notification
		if (next_unlock.category == "cosmetics") {
			draw_set_color(WHITE);
			draw_text(_rect_x + _rect_width/2, _rect_y + _rect_height - 50, "CHECK IT OUT IN THE HATS MENU!");
		}
	
		// lab log notification
		if (next_unlock.category == "lab_logs") {
			draw_set_color(WHITE);
			draw_text(_rect_x + _rect_width/2, _rect_y + _rect_height - 50, "READ UP IN THE LAB LOGS");
		}
		
		// inputs
		var _continue_icon = input_verb_get_icon("select");
		var _text_renderer = scribble("CLOSE: [" + sprite_get_name(_continue_icon) +"]");
		_text_renderer.starting_format("fnt_cutscene_default", WHITE).align(fa_center, fa_middle).draw(_rect_x + _rect_width - (_rect_width/4), _rect_y + string_height("CONTINUE"));
	}
});

fsm.add("idle", {
	enter: function() {
		global.unlock_progress = round(total_points); // ensure we are only saving rounded points
		set_save_data_property("unlock_progress", global.unlock_progress);
	},
	step: function() {
		if (input_check_pressed("quit")) {
	    	reset_game_state();
	    	quit_to_menu();
		}
			
		if (input_check_pressed("select")) {
			reset_game_state();
    		restart_game();
		}
	},
});