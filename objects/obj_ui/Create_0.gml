drawn_score = score;
shake_magnitude = 0;
shake_time = 0;
shake_fade = 0;
shake = false;
shake_x_offset = 0;
shake_y_offset = 0;
tutorial_banner_x = 0;
tutorial_banner_center_point = global.first_wave_complete ? -2000 : 0;
tutorial_banner_y = room_height/6;
tutorial_text_padding_left = 40;
show_tutorial = global.tutorial;
won_level = false;
victory_bg_x = -1 * room_width;
target_victory_bg_x = 0;
victory_bg_alpha = 0;
target_victory_bg_alpha = 0.7;
victory_banner_y = (room_height/2) - 120;
color_block_offset = 32;
color_blocks = [
	YELLOW,
	ORANGE,
	RED, 
	PURPLE,
	BLACK,
	SMALT_BLUE,
	GREEN,
	WILD_RICE,
	WHITE,
	PERANO,
	PORTAGE,
	EAST_BAY,
	BLUE,
	DARK_BLUE, 
	PINK,
	PERSIAN_PINK
]

shake_text = function(_time = 0, _magnitude = 0, _fade_rate = 0) {
	shake_time = _time;
	shake_magnitude = _magnitude;
	shake_fade = _fade_rate;
	shake = true;
}

// State Machine
fsm = new SnowState("start_level");

fsm.add("start_level", {
	enter: function() {
		victory_bg_x = target_victory_bg_x;
		victory_bg_alpha = 1;
	},
	
	step: function() {
		victory_bg_x = lerp(victory_bg_x, room_width * 2, 0.05);
		victory_bg_alpha = lerp(victory_bg_alpha, 0, 0.1);
		
		if (victory_bg_x >= room_width * 1.5) {
			fsm.change("mid_level");
		}
	},
	
	draw: function() {
		// Color background
		FOREACH color_blocks ELEMENT
			var _block_width = room_width + (color_block_offset * array_length(color_blocks));
			var _block_height = room_height / array_length(color_blocks);
			var _block_x = victory_bg_x - color_block_offset * _i;
			var _block_y = _i * _block_height;
			draw_set_color(_elem);
			draw_rectangle(_block_x, _block_y, _block_x + _block_width, _block_y + _block_height, false);	
		END
	},	
});

fsm.add("mid_level", {
	draw: function() {
		if (show_tutorial) {
			draw_set_color(c_black);
			draw_set_alpha(0.5);
			draw_rectangle(tutorial_banner_center_point, tutorial_banner_y - 20, room_width/2 + tutorial_banner_center_point, tutorial_banner_y + 120, false);
			draw_set_alpha(1);
	
			draw_set_halign(fa_left);
			draw_shadow_text(tutorial_text_padding_left + tutorial_banner_center_point , tutorial_banner_y, "WASD: move", global.moved ? GREEN : WHITE);
			draw_shadow_text(tutorial_text_padding_left + tutorial_banner_center_point , tutorial_banner_y + 20, "LEFT CLICK: shoot", global.shot ? GREEN : WHITE);
			draw_shadow_text(tutorial_text_padding_left + tutorial_banner_center_point , tutorial_banner_y + 40, "SPACE or RIGHT CLICK (HOLD): move fast", global.dashed ? GREEN : WHITE);
			draw_shadow_text(tutorial_text_padding_left + tutorial_banner_center_point , tutorial_banner_y + 80, "DON'T TOUCH THE WALLS!", ORANGE);
		}
	}
});

fsm.add("game_over", {
	step: function() {
		victory_bg_x = lerp(victory_bg_x, target_victory_bg_x, 0.05);
		victory_bg_alpha = lerp(victory_bg_alpha, target_victory_bg_alpha, 0.1);
	},
	
	draw: function() {
		// Color background
		FOREACH color_blocks ELEMENT
			var _block_width = room_width + (color_block_offset * array_length(color_blocks));
			var _block_height = room_height / array_length(color_blocks);
			var _block_x = victory_bg_x - color_block_offset * _i;
			var _block_y = _i * _block_height;
			draw_set_color(_elem);
			draw_rectangle(_block_x, _block_y, _block_x + _block_width, _block_y + _block_height, false);	
		END
		
		// Banner BG
		draw_set_color(c_black);
		draw_set_alpha(0.5);
		draw_rectangle(0, room_height/2 - 20, room_width, room_height/2 + 120, false);
		draw_set_alpha(1);
		
		// Banner Text
		draw_set_color(WHITE);
		draw_shadow_text(room_width/2, room_height/2 + 20, "FINAL SCORE: " + string(score));
		draw_shadow_text(room_width/2, room_height/2 + 40, "BEST SCORE: " + string(global.best_score));
		draw_shadow_text(room_width/2, room_height/2 + 60, "RETRY: spacebar");
		draw_shadow_text(room_width/2, room_height/2 + 80, "QUIT: escape");
	}
});

fsm.add("level_complete", {
	enter: function() {
		target_victory_bg_x = 0;
		victory_bg_alpha = 0;
		target_victory_bg_alpha = 0.7;
	},
	
	step: function() {
		victory_bg_x = lerp(victory_bg_x, target_victory_bg_x, 0.05);
		victory_bg_alpha = lerp(victory_bg_alpha, target_victory_bg_alpha, 0.1);
		
		if (input_check_pressed("select")) {
			room_restart();
		}
	},
	
	draw: function() {
		// Color background
		FOREACH color_blocks ELEMENT
			var _block_width = room_width + (color_block_offset * array_length(color_blocks));
			var _block_height = room_height / array_length(color_blocks);
			var _block_x = victory_bg_x - color_block_offset * _i;
			var _block_y = _i * _block_height;
			draw_set_color(_elem);
			draw_rectangle(_block_x, _block_y, _block_x + _block_width, _block_y + _block_height, false);	
		END
		
		// Text banners
		banner(100, victory_banner_y, "LEVEL COMPLETE", BLACK, victory_bg_alpha);
		banner(100, victory_banner_y + 120, "FINAL SCORE: " + string(score), BLACK, victory_bg_alpha);
		banner(100, victory_banner_y + 240, "PRESS SPACE TO CONTINUE", BLACK, victory_bg_alpha);
	},
	
});

// Event Subscriptions
subscribe(id, WON_LEVEL, function() {fsm.change("level_complete")});
subscribe(id, LOST_LEVEL, function() {fsm.change("game_over")});
