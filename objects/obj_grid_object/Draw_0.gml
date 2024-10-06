draw_sprite_ext(bg_sprite, 0, x, y, image_xscale, image_yscale, 0, fill_color, 1);
draw_sprite(data_sprite, 0, x, y);
draw_shadow_text(x, y + sprite_get_height(bg_sprite), data_name);