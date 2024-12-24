// TODO: refactor UI coding to not use precise "magic" numbers (need to calculate spacing b/t elements)

var _current_scene = get_current_scene();
if (_current_scene == undefined) {
	_current_scene = {
		goal_score: 20000,
        time_between_spawns: 30,
        max_enemy_count: 10,
	};
}

drawn_score = score;
shake_magnitude = 0;
shake_time = 0;
shake_fade = 0;
shake = false;
shake_x_offset = 0;
shake_y_offset = 0;
tutorial_banner_x = 0;
tutorial_banner_center_point = global.first_wave_complete ? -2000 : 0;
tutorial_banner_y = VIEW_HEIGHT/6;
tutorial_text_padding_left = 40;
show_tutorial = global.tutorial;
won_level = false;
boss_active = false;
goal_score = _current_scene.goal_score;

// Transition Animation
transition_bg_buffer = 64;
victory_bg_y = 0;
transition_bg_starting_x = -1 * sprite_get_width(spr_wipe_transition_base);
victory_bg_x = transition_bg_starting_x;
target_victory_bg_x = -1 * transition_bg_buffer;
victory_bg_alpha = 0;
target_victory_bg_alpha = 0.7;
victory_banner_y = (VIEW_HEIGHT/2) - 120;
animation_progress = 0;
animation_speed = 0.02;
animation = WipeTransition;

tile_x = 0;
tile_y = 0;
transition_surface = -1;

// test layering off effect (no game objects rendering on top)

shake_text = function(_time = 0, _magnitude = 0, _fade_rate = 0) {
	shake_time = _time;
	shake_magnitude = _magnitude;
	shake_fade = _fade_rate;
	shake = true;
}

animate_transition = function(_target_x) {
	var _curveStruct = animcurve_get(animation);
	var _channel = animcurve_get_channel(_curveStruct, "x");
	var _value = animcurve_channel_evaluate(_channel, animation_progress)
	
	var _distance = (_target_x - transition_bg_starting_x);
	victory_bg_x = transition_bg_starting_x + (_distance * _value);
	
	animation_progress += animation_speed;
	animation_progress = clamp(animation_progress, 0, 1);
}
draw_transition = function(_x, _y) {
		// if (!surface_exists(transition_surface)) {
		// 	transition_surface = surface_create(sprite_get_width(spr_wipe_transition_base), sprite_get_height(spr_wipe_transition_base));
		// }
		
		// surface_set_target(transition_surface);
		
		draw_sprite(spr_wipe_transition_base, 0, _x, _y);
		
		// gpu_set_colorwriteenable(1, 1, 1, 0);
		
		// draw_set_alpha(0.4);
		// draw_sprite_tiled(spr_tile_deck, 0, tile_x, tile_y);
		// draw_set_alpha(1);

		// gpu_set_colorwriteenable(1, 1, 1, 1);
		
		// surface_reset_target();
		
		// draw_surface(transition_surface, _x - sprite_get_xoffset(spr_wipe_transition_base), _y - sprite_get_yoffset(spr_wipe_transition_base));
}

// State Machine
fsm = new SnowState("start_level");

fsm.add("start_level", {
	enter: function() {
		animation_progress = 0;
		victory_bg_alpha = 1;
		target_victory_bg_x = VIEW_WIDTH;
	},
	
	step: function() {
		animate_transition(target_victory_bg_x);
		
		// enable the card for selection when animation is finished
		if (animation_progress >= 1) {
			fsm.change("mid_level");
		}
		
		// move tile animation
		tile_x += 1;
		tile_y += 1;
	},
	
	draw: function() {
		draw_transition(victory_bg_x, victory_bg_y);
	},	
});

fsm.add("mid_level", {
	draw_gui: function() {
		// -- Boss Lives
		if (boss_active) {
			var _boss_lives = global.boss_lives;
			var _lives_icon_margin = 16;
			var _boss_life_section_width = (sprite_get_width(spr_boss_life_icon) * 3) + (_lives_icon_margin * 2);
			var _lives_ui_x = VIEW_WIDTH/2 - _boss_life_section_width/2;
			var _boss_life_ui_y = VIEW_HEIGHT - sprite_get_height(spr_boss_life_icon);
			for(var _i = 0; _i < _boss_lives; _i++) {
				draw_sprite(spr_boss_life_icon, 0, _lives_ui_x + (sprite_get_width(spr_boss_life_icon) + _lives_icon_margin) * _i, _boss_life_ui_y);
			}
		}
	}
});

fsm.add("game_over", {
	enter: function() {
		animation_progress = 0;
		victory_bg_x = transition_bg_starting_x;
		victory_bg_alpha = 1;
		target_victory_bg_x = -1 * transition_bg_buffer;
	},
	
	step: function() {
		animate_transition(target_victory_bg_x);
		
		tile_x += 1;
		tile_y += 1;
	},
	
	draw: function() {
		draw_transition(victory_bg_x, victory_bg_y);
		
		// Banner Text
		var _banner_y = VIEW_WIDTH/2 - 100;
		draw_set_color(WHITE);
		draw_shadow_text(VIEW_WIDTH/2, _banner_y - 60, "FINAL SCORE: " + string(score));
		draw_shadow_text(VIEW_WIDTH/2, _banner_y - 30, "BEST SCORE: " + string(global.best_score));
		draw_shadow_text(VIEW_WIDTH/2, _banner_y, "RETRY: spacebar | EDIT DECK: 'R'");
		draw_shadow_text(VIEW_WIDTH/2, _banner_y + 30, "QUIT: escape");
	},
	
	leave: function() {
		transition_bg_starting_x = target_victory_bg_x;
	},
});

fsm.add("level_complete", {
	enter: function() {
		animation_progress = 0;
		target_victory_bg_x = 0;
		victory_bg_alpha = 0;
		target_victory_bg_alpha = 0.7;
	},
	
	step: function() {
		animate_transition(target_victory_bg_x);
		
		if (input_check_pressed("progress")) {
			global.temp_game_speed = 1;
			go_to_end_scene();
		}
	},
	
	draw: function() {
		draw_transition(victory_bg_x, victory_bg_y);
		
		// Text banners
		banner(100, victory_banner_y, "LEVEL COMPLETE", BLACK, victory_bg_alpha);
		banner(100, victory_banner_y + 120, "FINAL SCORE: " + string(score), BLACK, victory_bg_alpha);
		banner(100, victory_banner_y + 240, "PRESS SPACE TO CONTINUE", BLACK, victory_bg_alpha);
	},
	
});

fsm.add("game_complete", {
	enter: function() {
		target_victory_bg_x = 0;
		victory_bg_alpha = 0;
		target_victory_bg_alpha = 0.7;
		animation_progress = 0;
	},
	
	step: function() {
		animate_transition(target_victory_bg_x);
		
		if (input_check_pressed("progress")) {
			quit_to_menu();
		}
	},
	
	draw: function() {
		draw_transition(victory_bg_x, victory_bg_y);
		
		// Text banners
		banner(100, victory_banner_y, "VICTORY ACHIEVED", BLACK, victory_bg_alpha);
		banner(100, victory_banner_y + 120, "FINAL SCORE: " + string(score), BLACK, victory_bg_alpha);
		banner(100, victory_banner_y + 240, "PRESS SPACE TO CONTINUE", BLACK, victory_bg_alpha);
	},
	
});

// Event Subscriptions
subscribe(id, WON_LEVEL, function() {fsm.change("level_complete")});
subscribe(id, WON_GAME, function() {fsm.change("game_complete")});
subscribe(id, LOST_LEVEL, function() {fsm.change("game_over")});
subscribe(id, SPAWNED_BOSS, function() {boss_active = true;});
