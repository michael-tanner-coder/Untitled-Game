
// Text rendering
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_font(header_font);
var _header_text_y = y - string_height(header_text)/2;
var _header_width = string_width(header_text);
var _header_height = string_height(header_text);
draw_outlined_text(x, _header_text_y, header_text, header_text_color, header_font, 4, c_white);

draw_set_font(tip_font);
var _tip_text_y = _header_text_y + string_height(header_text) + text_margin;
var _tip_width = string_width(tip_text);
var _tip_height = string_height(tip_text);
draw_outlined_text(x, _tip_text_y, tip_text, tip_text_color, tip_font, 2, c_white);

// Outline rendering
if (outline_enabled) {
    var _outline_height = _tip_height + +_header_height + padding;
    var _max_text_width = max(_tip_width, _header_width);
    var _outline_width = _max_text_width + padding;
    var _outline_xscale = _outline_width / sprite_get_width(sprite_index);
    var _outline_yscale = _outline_height / sprite_get_height(sprite_index);
    
    image_xscale = _outline_xscale;
    image_yscale = _outline_yscale;
    
    draw_self();
}

