// Fade out object if it is not unlocked
image_alpha = unlocked ? 1 : 0.5;
draw_set_alpha(image_alpha);

// Background
draw_set_color(color);
draw_rectangle(x, y, x + width, y + height, false);

// Outline
if (highlighted) {
    draw_set_color(WHITE);
    draw_rectangle(x, y, x + width, y + height, true);
}

// Name
var _name = struct_get(level_data, "name");
if (_name != undefined && is_string(_name)) {
    draw_set_font(fnt_header_nonsdf);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_shadow_text(x + text_padding, y + height/2, _name);
}

// Card Collected
draw_set_font(fnt_default);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
var _string_height = string_height("Cards Collected: ");
var _card_set = struct_get(level_data, "card_set");
var _card_set_data = get_card_set_struct(_card_set);
var _cards = struct_get(_card_set_data, "cards");
draw_shadow_text(x + 340, y + height/2 - _string_height, "Cards Collected: " + string(cards_collected) + "/" + string(card_set_total));

// Card Progress
draw_shadow_text(x + 340, y + height/2 + _string_height, "Next Card: ");
var _progress_percent = card_unlock_progress / card_unlock_progress_limit;
var _string_width = string_width("Next Card: ");
fillbar(x + 340 + _string_width, y + 4 + height/2 + _string_height/2 + progress_bar_height/2, progress_bar_width, progress_bar_height, _progress_percent, card_unlock_progress_bar_fill_color, card_unlock_progress_bar_base_color);

// Reset drawing
draw_set_alpha(1);