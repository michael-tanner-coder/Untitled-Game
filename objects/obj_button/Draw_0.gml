
draw_set_alpha(image_alpha);

// Sprite
if (use_nine_slice) {
	image_xscale = width;
	image_yscale = height;
	draw_sprite_stretched(sprite, 0, x, y, width, height);
}
else {
	draw_sprite(sprite, 0, x, y);
}

// Text
var _shadow_text_renderer = scribble(text);
_shadow_text_renderer.starting_format("fnt_default", PURPLE).align(fa_center, fa_middle).wrap(width - text_padding).draw((x + width/2) + 2, (y + height/2) + 2);
var _text_renderer = scribble(text);
_text_renderer.starting_format("fnt_default", WHITE).align(fa_center, fa_middle).wrap(width - text_padding).draw(x + width/2, y + height/2);

draw_set_alpha(1);