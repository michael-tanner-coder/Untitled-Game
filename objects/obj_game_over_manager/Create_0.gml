fill_sprite = spr_progress_bar_fill;
outline_sprite = spr_progress_bar_outline;
outline_size = 6;
bar_margin = 20;
banner_x = -1000;

progress_points = global.unlock_progress[$ global.chosen_level][$ "current_points"];
total_points = progress_points + score;
points_from_score = 0;

item_name = "";
item_data = undefined;

progress_bar_width = 400;
progress_bar_height = 50;
new_card = undefined;

// Methods
default_draw_behavior = function() {
	draw_set_color(WHITE);
	
	var _required_points = global.unlock_progress[$ global.chosen_level][$ "required_points"];
	if (is_numeric(_required_points)) {
		var _progress_percent = progress_points / _required_points;
		_progress_percent = clamp(_progress_percent, 0, 1);
	
		draw_set_halign(fa_center);
		draw_set_color(WHITE);
		
		banner(200, y - 100, "", BLACK, 0.7);
	
		var _formatted_points = string_format(round(progress_points), 0, 0);
		var _required_points = global.unlock_progress[$ global.chosen_level][$ "required_points"];
		draw_text(x + sprite_get_width(outline_sprite)/2, y - sprite_get_height(outline_sprite) - bar_margin, _formatted_points + "/" + string(_required_points));
	
		var _level_data = get_level_struct(global.chosen_level); // TODO: refactor this to pull the data once in the create event
		var _color = struct_get(_level_data, "color");
		fillbar(room_width/2 - progress_bar_width/2, y, progress_bar_width, progress_bar_height, _progress_percent, _color, WHITE);
	
		draw_set_color(WHITE);
		draw_text(x + sprite_get_width(outline_sprite) / 2, y + sprite_get_height(outline_sprite) + (bar_margin*2), "PROGRESS TO UNLOCK NEXT CARD");
	}
}

// State Machine
fsm = new SnowState("inactive");

fsm.add("inactive", {
	step: function() {},
	draw: function() {},
});

fsm.add("idle", {
	enter: function() {
		global.unlock_progress[$ global.chosen_level][$ "current_points"] = round(progress_points); // ensure we are only saving rounded points
		set_save_data_property(UNLOCK_PROGRESS_POINTS, global.unlock_progress);
	},
	step: function() {
		if (input_check_pressed("quit")) {
	    	reset_game_state();
	    	quit_to_menu();
		}
		
		if (input_check_pressed("progress")) {
			room_restart();
		}
		
		// go to deck Menu
		if (input_check_pressed("view_deck")) {
			room_goto(rm_item_menu);
		}
	},
	draw: function() {
		default_draw_behavior();
	}
});

fsm.add("countup", {
	enter: function() {
		progress_points = global.unlock_progress[$ global.chosen_level][$ "current_points"];
		total_points = progress_points + points_from_score;
		item_name = "";
	},
	step: function() {
		// gradually increase progress_points until it equals target_points
		var _required_points = global.unlock_progress[$ global.chosen_level][$ "required_points"];
		var _target_points = min(total_points, _required_points);
		progress_points = lerp(progress_points, _target_points, 0.1);
		progress_points = clamp(progress_points, 0, _target_points);
		if (abs(progress_points - _target_points) < 1) {
			progress_points = _target_points;
		}
	
		// let player restart level if we have completed the progress animation
		if (input_check_pressed("progress") && progress_points == _target_points) {
			room_restart();
		}
		
		// skip progress bar animation
		if (input_check_pressed("progress")) {
			progress_points = _target_points;
		}
		
		// move to unlock state if we cleared the point requirement for the next unlock
		if (is_numeric(_required_points) && progress_points >= _required_points) {
			fsm.change("unlock");
			return;
		}
		
		// move to idle state if we did not unlock anything new and have reached the end of the progress bar animation
		if (progress_points == total_points) {
			fsm.change("idle");
		}
		else {
			play_sound(snd_progress_bar_count, false);
		}
	},
	draw: function() {
		default_draw_behavior();
	}
});

fsm.add("unlock", {
	enter: function() {
		// pull card set data from active level
		var _level_key = global.chosen_level;
		var _level_data = get_level_struct(_level_key);
		var _card_set_key = struct_get(_level_data, "card_set");
		var _card_set_struct = get_card_set_struct(_card_set_key);
		var _card_keys = struct_get(_card_set_struct, "cards");
		
		// use card set data to find a weighted random card
		var _struct_collection = build_deck_of_structs(_card_keys);
		var _random_card = get_weighted_random_card(_struct_collection);
		show_debug_message("_random_card.key");
		show_debug_message(_random_card.key);
		var _unlocked_card = unlock_card(_random_card.key);
	
		// get item data for display
		item_data = get_unlock_item_data(_unlocked_card);
		item_name = item_data.name;
		new_card = new_card_instance(item_data.key)
		
		// reset target points for next time we go to the countup state
		var _level_point_limit = global.unlock_progress[$ global.chosen_level][$ "max_points"];
		var _required_points = global.unlock_progress[$ global.chosen_level][$ "required_points"];
		var _current_points = global.unlock_progress[$ global.chosen_level][$ "current_points"];
		
		points_from_score -= (_required_points - _current_points);
		points_from_score = clamp(points_from_score, 0, score);
		progress_points = 0;
		
		_required_points *= 2;
		
		global.unlock_progress[$ global.chosen_level][$ "current_points"] = 0;
		global.unlock_progress[$ global.chosen_level][$ "required_points"] = clamp(_required_points, 0, _level_point_limit);
		
		set_save_data_property("card_unlock_progress", global.unlock_progress);
		
		play_sound(snd_tutorial_success);
		
		global.unlock_modal_open = true;
	},
	step: function() {
		// adds card to deck; adds to collection if deck is full
		if (input_check_pressed("view_deck") && array_length(global.active_deck) < global.deck_limit) {
			add_to_deck(new_card, global.active_deck.cards);
			save_deck(global.active_deck);
			add_to_collection(new_card);
			fsm.change("countup");
			global.unlock_modal_open = false;
		}
		
		if (input_check_pressed("progress")) {
			add_to_collection(new_card);
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
		
		// header
		draw_set_font(fnt_header);
		draw_shadow_text(_rect_x + _rect_width/2, _rect_y + 40, "NEW CARD UNLOCKED!", WHITE, PURPLE)
		
		// item name
		draw_shadow_text(_rect_x + _rect_width/2, _rect_y + 100, item_name, WHITE, PURPLE)
		
		// item description
		draw_set_font(fnt_paragraph);
		var _description = struct_get(item_data, "description");
		draw_shadow_text(_rect_x + _rect_width/2, _rect_y + 200, _description, WHITE, PURPLE);
		
		// inputs
		draw_set_font(fnt_header);
		draw_shadow_text(_rect_x + _rect_width/2, _rect_y + 250, "ADD TO DECK: R", WHITE, PURPLE);
		draw_shadow_text(_rect_x + _rect_width/2, _rect_y + 300, "PRESS SPACE TO CONTINUE", WHITE, PURPLE)
	}
});

// Event Subscriptions
subscribe(id, LOST_LEVEL, function() {
	points_from_score = score;
	fsm.change("countup");
});