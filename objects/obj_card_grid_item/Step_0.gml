if (highlighted && mouse_check_button_pressed(mb_left)) {
    show_debug_message("CLICKED CARD:");
    show_debug_message(struct_get(card_data, "name"));
    
    event_payload = {card_data: card_data, card_instance: id};
    publish(on_click_event, event_payload);
}

image_xscale = selected ? 1.2 : 1;
image_yscale = selected ? 1.2 : 1;