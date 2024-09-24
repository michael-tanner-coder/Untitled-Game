// Text rendering
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_font(font);
if (outline_enabled) {
    draw_outlined_text(x, y, text, text_color, font, 4, outline_color);
}
else {
    draw_set_color(text_color);
    draw_text(x,y,text);
}

if (input != undefined) {
    var _label_width = string_width(text);
    drawInput(x + _label_width, y, input, font, 0, text_color, text_color, 1, true);
}

