// debug
draw_set_color(RED);
physics_draw_debug();

// alignment
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// fade in
draw_set_font(font);
draw_set_alpha(text_alpha);

// main text
draw_set_color(PURPLE);
draw_text_transformed(phy_position_x + 2 + shake_x_offset, phy_position_y + 2 + shake_y_offset, text, 1, 1, -phy_rotation);
draw_set_color(default_text_color);
draw_text_transformed(phy_position_x + shake_x_offset, phy_position_y + shake_y_offset, text, 1, 1, -phy_rotation);

// reset/cleanup
draw_set_alpha(1);