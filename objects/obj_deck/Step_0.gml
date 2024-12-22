if (highlighted && input_check_double_pressed("select")) {
    event_payload = deck_data;
    publish(on_click_event, event_payload);
}