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

progress_bar_width = 400;
progress_bar_height = 50;

// Methods
default_draw_behavior = function() {
	draw_set_color(WHITE);
	if (next_unlock == undefined) {
		banner(100, y, "NO MORE UNLOCKS", BLACK, 0.7);
		return;
	}
	
	if (is_numeric(next_unlock.required_points)) {
		var _progress_percent = progress_points / next_unlock.required_points;
		_progress_percent = clamp(_progress_percent, 0, 1);
	
		draw_set_halign(fa_center);
		draw_set_color(WHITE);
		
		banner(200, y - 100, "", BLACK, 0.7);
	
		var _formatted_points = string_format(round(progress_points), 0, 0);
		draw_text(x + sprite_get_width(outline_sprite)/2, y - sprite_get_height(outline_sprite) - bar_margin, _formatted_points + "/" + string(next_unlock.required_points));
	
		fillbar(room_width/2 - progress_bar_width/2, y, progress_bar_width, progress_bar_height, _progress_percent, RED, WHITE);
	
		draw_set_color(WHITE);
		draw_text(x + sprite_get_width(outline_sprite) / 2, y + sprite_get_height(outline_sprite) + (bar_margin*2), "PROGRESS TO NEXT UNLOCK");
	}
}

// State Machine
fsm = new SnowState("inactive");

fsm.add("countup", {
	enter: function() {
		progress_points = global.unlock_progress;
		total_points = global.unlock_progress + score;
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
	draw: function() {
		default_draw_behavior();
	}
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
		
		global.unlock_modal_open = true;
	},
	step: function() {
		if (input_check_pressed("select")) {
			fsm.change("countup");
			global.unlock_modal_open = false;
		}
		
		banner_x = lerp(banner_x, 0, 0.2);
	},
	draw: function() {
		default_draw_behavior();
		
		var _rect_x = banner_x;
		var _rect_y = 0;
		var _rect_width = room_width;
		var _rect_height = room_height;
		
		// banner overlay
		draw_set_color(c_black);
		draw_set_alpha(0.75);
		draw_rectangle(_rect_x, _rect_y, _rect_x + _rect_width, _rect_y + _rect_height, false);
		draw_set_alpha(1);
		
		draw_set_font(fnt_header);
		
		// header
		draw_shadow_text(_rect_x + _rect_width/2, _rect_y + 40, "NEW UNLOCK!", WHITE, PURPLE)
		
		// item name
		draw_shadow_text(_rect_x + _rect_width/2, _rect_y + 100, item_name, BLUE, WHITE)
		
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
	draw: function() {
		default_draw_behavior();
	}
});

fsm.add("inactive", {
	step: function() {},
	draw: function() {},
});

// Event Subscriptions
subscribe(id, LOST_LEVEL, function() {
	fsm.change("countup");
});