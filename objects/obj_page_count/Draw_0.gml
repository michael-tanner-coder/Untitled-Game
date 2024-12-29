// Base
draw_sprite_stretched(sprite_index, 0, x, y, width, height);

// Page Icons
var _x = x + page_icon_padding;
var _y = y + page_icon_padding/2;
for(var _i = 0; _i < page_count; _i++) {
    var _icon_color = current_page == _i ? current_page_icon_color : default_page_icon_color;
    draw_sprite_ext(page_icon, 0, _x, _y, 1, 1, 0, _icon_color, 1);
    _x += sprite_get_width(page_icon) + page_icon_margin_x;
}
