draw_self();

// Header
draw_shadow_text(x + width/2, y + 25, header);

// Sprite
draw_sprite(sprite, 0, x + width/2, y + 60);

// Price
draw_shadow_text(x + width/2, y + 70 + sprite_get_height(sprite), "$" + string(price));

// Description
var _text_renderer = scribble(description);
_text_renderer.starting_format("fnt_default", WHITE).align(fa_left, fa_top).wrap(width - description_padding).draw(x + description_padding, y + 90 + sprite_get_height(sprite));
