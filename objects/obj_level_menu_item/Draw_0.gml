// Fade out object if it is not unlocked
image_alpha = unlocked ? 1 : 0.5;
draw_set_alpha(image_alpha);

// Background
draw_set_color(color);
draw_rectangle(x, y, x + width, y + height, false);

// Text
var _name = struct_get(level_data, "name");
if (_name != undefined && is_string(_name)) {
    draw_set_font(fnt_header_nonsdf);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_shadow_text(x + text_padding, y + height/2, _name);
}

// Reset drawing
draw_set_alpha(1);