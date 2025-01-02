draw_self();

// Header
draw_set_font(description_font);
draw_shadow_text(x + sprite_get_width(sprite_index)/2, y + sprite_get_height(sprite_index)/2, header, PURPLE, WHITE);

// Sprite
// draw_sprite(sprite, 0, x + width/2, y + 60);

// Activation Cost
draw_set_font(description_font);
var _text_height = string_height(string(price));
draw_sprite_ext(spr_mana_icon, 0, x + width/2 - (sprite_get_width(spr_mana_icon) * 2), y + sprite_get_height(sprite_index) - _text_height, 1, 1, 0, c_white, 1);
draw_shadow_text(x + width/2, y + sprite_get_height(sprite_index) - _text_height, string(price), PURPLE, WHITE);

// Description
// var _text_renderer = scribble(description);
// _text_renderer.starting_format("fnt_small", WHITE).align(fa_left, fa_top).wrap(width - description_padding).draw(x + description_padding, y + 90 + sprite_get_height(sprite));
