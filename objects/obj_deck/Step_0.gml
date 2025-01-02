if (highlighted && mouse_check_button_pressed(mb_left)) {
    show_debug_message("CLICKED DECK:");
    show_debug_message(struct_get(deck_data, "name"));
    
    event_payload = {deck_data: deck_data, deck_instance: id};
    publish(on_click_event, event_payload);
}

image_xscale = selected ? 1.2 : 1;
image_yscale = selected ? 1.2 : 1;