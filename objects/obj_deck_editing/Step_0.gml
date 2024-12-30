page_counter.page_count = page_count;
page_counter.current_page = current_page;
page_counter.x = room_width/2 - page_counter.width/2;

tooltip.anchor_x = -1000;
tooltip.anchor_y = -1000;
var _tooltip = tooltip;
with(record_object) {
    if (highlighted) {
        _tooltip.anchor_x = x + sprite_get_width(sprite_index);
        _tooltip.anchor_y = y;
        _tooltip.header = struct_get(card_data, "name");
        _tooltip.text = struct_get(card_data, "description");
    }
}

if (fsm.event_exists("step")) {
    fsm.step();
}