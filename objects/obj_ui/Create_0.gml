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
show_tutorial = get_flag("needs_tutorial");
won_level = false;

shake_text = function(_time = 0, _magnitude = 0, _fade_rate = 0) {
	shake_time = _time;
	shake_magnitude = _magnitude;
	shake_fade = _fade_rate;
	shake = true;
}

// State Machine
fsm = new SnowState("mid_level");

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
	draw: function() {
		draw_set_color(c_black);
		draw_set_alpha(0.5);
		draw_rectangle(0, room_height/2 - 20, room_width, room_height/2 + 120, false);
		draw_set_alpha(1);
		
		draw_set_color(WHITE);
		draw_shadow_text(room_width/2, room_height/2 + 20, "FINAL SCORE: " + string(score));
		draw_shadow_text(room_width/2, room_height/2 + 40, "BEST SCORE: " + string(global.best_score));
		draw_shadow_text(room_width/2, room_height/2 + 60, "RETRY: spacebar");
		draw_shadow_text(room_width/2, room_height/2 + 80, "QUIT: escape");
	}
});

fsm.add("level_complete", {
	draw: function() {
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_shadow_text(room_width/2, room_height/2, "LEVEL COMPLETE");
		draw_shadow_text(room_width/2, room_height/2 + 80, "FINAL SCORE: " + string(score));
	},
});

// Event Subscriptions
subscribe(id, WON_LEVEL, function() {fsm.change("level_complete")});
subscribe(id, LOST_LEVEL, function() {fsm.change("game_over")});
