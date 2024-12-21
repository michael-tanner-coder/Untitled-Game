image_xscale = width;
image_yscale = height;

draw_set_alpha(image_alpha);

// Sprite
draw_sprite_stretched(sprite, 0, x, y, width, height);

// Text
var _text_renderer = scribble(text);
_text_renderer.starting_format("fnt_small", WHITE).align(fa_center, fa_middle).wrap(width - text_padding).draw(x + width/2, y + height/2);

draw_set_alpha(1);
