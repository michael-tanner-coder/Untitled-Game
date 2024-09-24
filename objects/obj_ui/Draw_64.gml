draw_set_font(fnt_default);
draw_set_color(WHITE);
draw_set_halign(fa_center);
var _formatted_score = string(round(drawn_score));
draw_shadow_text(room_width/2 + shake_x_offset, 10 + shake_y_offset, "SCORE: " + _formatted_score);

if (lives < 1) {
	draw_set_color(c_black);
	draw_set_alpha(0.5);
	draw_rectangle(0, room_height/2 - 20, room_width, room_height/2 + 120, false);
	draw_set_alpha(1);
	
	draw_set_color(WHITE);
	draw_shadow_text(room_width/2, room_height/2 + 20, "FINAL SCORE: " + string(score));
	draw_shadow_text(room_width/2, room_height/2 + 40, "BEST SCORE: " + string(global.best_score));
	draw_shadow_text(room_width/2, room_height/2 + 60, "RETRY: spacebar");
}

// TUTORIAL PROMPT
draw_set_color(c_black);
draw_set_alpha(0.5);
draw_rectangle(tutorial_banner_center_point, tutorial_banner_y - 20, room_width/2 + tutorial_banner_center_point, tutorial_banner_y + 120, false);
draw_set_alpha(1);

draw_set_halign(fa_left);
draw_shadow_text(tutorial_text_padding_left + tutorial_banner_center_point , tutorial_banner_y, "WASD: move", global.moved ? GREEN : WHITE);
draw_shadow_text(tutorial_text_padding_left + tutorial_banner_center_point , tutorial_banner_y + 20, "LEFT CLICK: shoot", global.shot ? GREEN : WHITE);
draw_shadow_text(tutorial_text_padding_left + tutorial_banner_center_point , tutorial_banner_y + 40, "SPACE or RIGHT CLICK (HOLD): move fast", global.dashed ? GREEN : WHITE);
draw_shadow_text(tutorial_text_padding_left + tutorial_banner_center_point , tutorial_banner_y + 80, "DON'T TOUCH THE WALLS!", ORANGE);




