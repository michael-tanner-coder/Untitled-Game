// Base textbox sprite
draw_self();

// Text renderer
var _text_renderer = scribble(text_content);
_text_renderer.starting_format("fnt_cutscene_default", BLACK).page(page_number).wrap(textbox_width).draw(x + padding_x, y + padding_y, typist);

// Text events
if (page_started && array_length(pages) > 0) {
    var _events = parse_scribble_events(pages[page_number]);
    show_debug_message(speaker);
    FOREACH _events ELEMENT
        var _event = _elem;
        if (speaker != undefined && is_array(_event) && speaker[$ _event[0]]) {
            speaker[$ _event[0]](_event[1]);
        }
    END
    page_started = false;
}

// Text renderer status
var _current_page_finished = typist.get_state() == 1;
var _on_last_page = _text_renderer.get_page() == _text_renderer.get_page_count() - 1;

// Input icon
if (_current_page_finished) {
    var _base_icon_y = y + sprite_get_height(sprite_index) - (padding_y * 5);
    var _sine_icon_y = sine_wave(current_time / 2000, 1, 4, _base_icon_y);
    draw_sprite(spr_shop_cursor_icon, 0, x + sprite_get_width(sprite_index) - padding_x, _sine_icon_y);
}

// Detect if we've finished a dialogue sequence
if (_on_last_page && _current_page_finished) {
    page_finished = true;
}

