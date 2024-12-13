// HUD
draw_set_font(fnt_default);
draw_set_color(WHITE);
draw_set_halign(fa_center);

var _hud_element_y = 20;

// -- Score
var _score_x = 180;
var _formatted_score = string_format(round(drawn_score), 10, 0);
draw_set_halign(fa_left);
draw_shadow_text(_score_x + shake_x_offset, _hud_element_y + shake_y_offset, string_replace_all(_formatted_score, " ", "0"));

// -- Progress
var _progress_bar_margin_y = 8;
var _score_height = string_height(_formatted_score);
var _progress_bar_x = _score_x;
var _progress_bar_y = (_hud_element_y + _score_height/2) + _progress_bar_margin_y;
draw_sprite(spr_level_progress_bar, 0, _progress_bar_x, _progress_bar_y);

var _marker_progress = clamp(score/goal_score, 0, 1);
var _progress_bar_width = sprite_get_width(spr_level_progress_bar);
var _marker_height = sprite_get_height(spr_level_progress_marker);
var _marker_x = (_progress_bar_x) + (_progress_bar_width * _marker_progress);
draw_sprite(spr_level_progress_marker, 0, _marker_x, (_progress_bar_y) - (_marker_height/2));

var _trophy_height = sprite_get_height(spr_trophy);
var _trophy_margin_x = 4;
draw_sprite(spr_trophy, 0, (_progress_bar_x + _progress_bar_width) + _trophy_margin_x, _progress_bar_y - _trophy_height/2)

// -- Mana
var _formatted_mana = string_format(round(global.currency), 5, 0);
var _mana_string = string_replace_all(_formatted_mana, " ", "0");
var _mana_string_width = string_width(_mana_string);
var _base_string_width = string_width("00000");
var _mana_ui_x = VIEW_WIDTH - _base_string_width - 28;
var _mana_ui_y = 15 + (36/2);
var _mana_icon_padding = 4;
draw_sprite_ext(spr_mana_icon, 0, _mana_ui_x - (sprite_get_width(spr_mana_icon)) - _mana_icon_padding, _mana_ui_y, 1, 1, 0, c_white, 1);
draw_set_halign(fa_left);
draw_shadow_text(_mana_ui_x, _mana_ui_y, _mana_string);

// -- Lives
var _lives_ui_x = sprite_get_width(spr_life);
var _lives_ui_y = _mana_ui_y-sprite_get_height(spr_mana_icon)/2;
var _lives_icon_margin = 10;
for(var _i = 0; _i < global.max_player_lives; _i++) {
	if (_i < lives) {
		draw_sprite(spr_life, 0, _lives_ui_x + (sprite_get_width(spr_life) + _lives_icon_margin) * _i, _lives_ui_y);
	}
	else {
		draw_sprite(spr_life_slot, 0, _lives_ui_x + (sprite_get_width(spr_life) + _lives_icon_margin) * _i, _lives_ui_y);
	}
}

if (fsm.event_exists("draw_gui")) {
	fsm.draw_gui();
}
