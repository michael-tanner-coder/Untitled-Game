// HUD
draw_set_font(fnt_default);
draw_set_color(WHITE);
draw_set_halign(fa_center);
var _formatted_score = string(round(drawn_score));
draw_shadow_text(room_width/2 + shake_x_offset, 10 + shake_y_offset, "SCORE: " + _formatted_score);

if (fsm.event_exists("draw"))
{
	fsm.draw();
}
