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

// Victory Banner
victory_bg_alpha = 0;
target_victory_bg_alpha = 0.7;
victory_banner_y = (VIEW_HEIGHT/2) - 120;

// Transition Effect
transition_surface = -1;
transition_effect_object = obj_wipe_transition;
transition_effect_instance = undefined;

unlocked_level = false;

// test card pattern with draw surfaces

shake_text = function(_time = 0, _magnitude = 0, _fade_rate = 0) {
	shake_time = _time;
	shake_magnitude = _magnitude;
	shake_fade = _fade_rate;
	shake = true;
}

spawn_transition_effect = function() {
	transition_effect_instance = instance_create_layer(x, y, layer, transition_effect_object);
	transition_effect_instance.starting_x = -1 * sprite_get_width(transition_effect_instance.sprite_index);
	transition_effect_instance.target_x = -1 * transition_effect_instance.x_buffer
	transition_effect_instance.start_animation();
	transition_effect_instance.depth = depth - 1;
}

// State Machine
fsm = new SnowState("start_level");

fsm.add("start_level", {
	enter: function() {
		transition_effect_instance = instance_create_layer(x, y, layer, transition_effect_object);
		transition_effect_instance.target_x = sprite_get_width(transition_effect_instance.sprite_index);
		transition_effect_instance.start_animation();
	},
	
	step: function() {
		if (transition_effect_instance != undefined && transition_effect_instance.animation_progress >= 1) {
			fsm.change("mid_level");
		}
	},
	
	draw: function() {},
	
	leave: function() {
		instance_destroy(transition_effect_instance);
	}
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
		spawn_transition_effect();
	},
	
	step: function() {},
	
	draw_gui: function() {
		var _banner_y = VIEW_WIDTH/2 - 100;
		draw_set_color(WHITE);
		draw_set_halign(fa_center);
		draw_shadow_text(VIEW_WIDTH/2, _banner_y - 60, "FINAL SCORE: " + string(score));
		draw_shadow_text(VIEW_WIDTH/2, _banner_y - 30, "BEST SCORE: " + string(global.best_score));
		draw_shadow_text(VIEW_WIDTH/2, _banner_y, "RETRY: spacebar | EDIT DECK: 'R'");
		draw_shadow_text(VIEW_WIDTH/2, _banner_y + 30, "QUIT: escape");
	},
	
	leave: function() {
		instance_destroy(transition_effect_instance);
	}
});

fsm.add("level_complete", {
	enter: function() {
		spawn_transition_effect();
		
		// unlock next level
		var _next_scene = get_next_scene();
		var _unlock_struct = {category: "levels", key: _next_scene.key};
		var _unlock_data = get_unlock_item_data(_unlock_struct);
		if (_unlock_data != undefined) {
			if (!is_unlocked(_unlock_struct)) {
				unlock_item(_unlock_struct);
				unlocked_level = true;
			}
		}
	},
	
	step: function() {
		if (input_check_pressed("progress")) {
			global.temp_game_speed = 1;
			
			// either go to game ending or main menu, depending on if we are at the last level or not
			var _next_scene = get_next_scene();
			if (_next_scene != undefined && _next_scene.key == "victory") {
				go_to_end_scene();
			} else if (_next_scene != undefined) {
				quit_to_menu();
			}
			
		}
	},
	
	draw_gui: function() {
		draw_set_color(WHITE);
		draw_set_halign(fa_center);
		banner(100, victory_banner_y, "LEVEL COMPLETE", BLACK, victory_bg_alpha);
		banner(100, victory_banner_y + 120, "FINAL SCORE: " + string(score), BLACK, victory_bg_alpha);
		banner(100, victory_banner_y + 240, "PRESS SPACE TO CONTINUE", BLACK, victory_bg_alpha);
		if (unlocked_level) {
			banner(100, victory_banner_y-40, "UNLOCKED NEW LEVEL!", YELLOW, victory_bg_alpha);
		}
	},
	
});

fsm.add("game_complete", {
	enter: function() {
		spawn_transition_effect();
	},
	
	step: function() {
		if (input_check_pressed("progress")) {
			quit_to_menu();
		}
	},
	
	draw: function() {
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
