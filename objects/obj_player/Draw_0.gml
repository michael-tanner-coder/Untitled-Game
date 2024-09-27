// Flicker rendering when iframes are active
if (i_frames % 8 == 0) {
	draw_self();
}

// Display remaining Lives UI
var _lives_ui_x = 30;
var _lives_ui_y = 80;
var _lives_icon_margin = 10;
for(var _i = 0; _i < upgrade_stats.player_lives; _i++) {
	draw_sprite(sprite_index, 0, _lives_ui_x + (sprite_get_width(sprite_index) + _lives_icon_margin) * _i, _lives_ui_y);
}