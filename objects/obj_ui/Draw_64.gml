// HUD
draw_set_font(fnt_default);
draw_set_color(WHITE);
draw_set_halign(fa_center);

var _hud_element_y = 14;

// -- Score
var _formatted_score = string_format(round(drawn_score), 8, 0);
var _formatted_mana = string_format(round(global.currency), 5, 0);
draw_shadow_text(VIEW_WIDTH/2 + shake_x_offset, _hud_element_y + shake_y_offset, "SCORE: " + string_replace_all(_formatted_score, " ", "0"));

// -- Mana
var _mana_string = string_replace_all(_formatted_mana, " ", "0");
var _mana_string_width = string_width(_mana_string);
var _mana_ui_x = VIEW_WIDTH - _mana_string_width;
var _mana_icon_padding = 4;
draw_sprite_ext(spr_mana_icon, 0, _mana_ui_x - (sprite_get_width(spr_mana_icon) * 2) - _mana_icon_padding, _hud_element_y, 1, 1, 0, c_white, 1);
draw_shadow_text(_mana_ui_x, _hud_element_y, _mana_string);

// -- Lives
var _lives_ui_x = sprite_get_width(spr_life);
var _lives_icon_margin = 10;
for(var _i = 0; _i < lives; _i++) {
	draw_sprite(spr_life, 0, _lives_ui_x + (sprite_get_width(spr_life) + _lives_icon_margin) * _i, _hud_element_y);
}

if (fsm.event_exists("draw_gui")) {
	fsm.draw_gui();
}
