// Sprite
draw_sprite_stretched(sprite_index, 0, x, y, width, height);

// text
var _text_renderer = scribble(text);
_text_renderer.starting_format("fnt_small", WHITE).align(fa_center, fa_middle).wrap(width - text_padding).draw(x + width/2, y + height/2);
