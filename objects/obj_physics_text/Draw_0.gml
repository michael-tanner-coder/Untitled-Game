draw_set_color(RED);
physics_draw_debug();
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(font);
draw_set_color(hit ? WHITE : PURPLE);
draw_text_transformed(phy_position_x + 2, phy_position_y + 2, text, 1, 1, -phy_rotation);
draw_set_color(hit ? PURPLE : WHITE);
draw_text_transformed(phy_position_x, phy_position_y, text, 1, 1, -phy_rotation);