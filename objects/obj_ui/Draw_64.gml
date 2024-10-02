// HUD
draw_set_font(fnt_default);
draw_set_color(WHITE);
draw_set_halign(fa_center);
var _formatted_score = string(round(drawn_score));
draw_shadow_text(room_width/2 + shake_x_offset, 10 + shake_y_offset, "SCORE: " + _formatted_score + "/" + string(goal_score));

// Display remaining Lives UI
var _lives_ui_x = room_width/2 - (6 * 64);
var _lives_ui_y = 32;
var _lives_icon_margin = 10;
for(var _i = 0; _i < lives; _i++) {
	draw_sprite(spr_player, 0, _lives_ui_x + (sprite_get_width(spr_player) + _lives_icon_margin) * _i, _lives_ui_y);
}

if (fsm.event_exists("draw")) {
	fsm.draw();
}
