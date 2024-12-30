// Base
draw_sprite_stretched(spr_tooltip, 0, x, y, width, height);

// Header
var _header_renderer = scribble(header);
_header_renderer.starting_format("fnt_default", WHITE).align(fa_left, fa_top).wrap(width - padding).draw(x + padding, y);

// 
var _text_renderer = scribble(text);
_text_renderer.starting_format("fnt_small", WHITE).align(fa_left, fa_top).wrap(width - padding).draw(x + padding, y + header_section_height + padding);
