var _block_width = sprite_get_width(bg_sprite);
var _block_height = sprite_get_height(bg_sprite);
draw_sprite_ext(bg_sprite, 0, x, y, image_xscale, image_yscale, 0, fill_color, 1);
draw_sprite(data_sprite, 0, x + _block_width/2, y + _block_height/2);
draw_set_font(fnt_paragraph);
draw_set_halign(fa_center);
draw_shadow_text(x + _block_width/2, y + _block_height + text_margin, data_name);