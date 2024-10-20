// HUD
draw_set_font(fnt_default);
draw_set_color(WHITE);
draw_set_halign(fa_center);

var _hud_element_y = 10;

// -- Score
var _formatted_score = string_format(round(drawn_score), 8, 0);
var _formatted_money = string_format(round(global.currency), 5, 0);
draw_shadow_text(room_width/2 + shake_x_offset, _hud_element_y + shake_y_offset, "SCORE: " + string_replace_all(_formatted_score, " ", "0"));

// -- Money
var _money_string = string_replace_all(_formatted_money, " ", "0");
var _money_string_width = string_width(_money_string);
draw_shadow_text(room_width - _money_string_width, _hud_element_y, "$" + _money_string);

// -- Lives
var _lives_ui_x = sprite_get_width(spr_life);
var _lives_icon_margin = 10;
for(var _i = 0; _i < lives; _i++) {
	draw_sprite(spr_life, 0, _lives_ui_x + (sprite_get_width(spr_life) + _lives_icon_margin) * _i, _hud_element_y);
}

if (fsm.event_exists("draw")) {
	fsm.draw();
}
