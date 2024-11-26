// Color Update
if (highlighted) {
    fill_color = PINK;
}
else {
    fill_color = default_color;
}

if (is_in_deck(data_instance_struct)) {
    default_color = GREEN;
}
else {
    default_color = WHITE;
}

// Card Selection
if (highlighted && mouse_check_button_pressed(mb_left)) {
    if (is_in_deck(data_instance_struct)) {
        remove_from_deck(data_instance_struct);
        add_to_collection(data_instance_struct);
    } else {
        add_to_deck(data_instance_struct);
        remove_from_collection(data_instance_struct);
    }
}