highlighted = unlocked && mouse_y >= y && mouse_y <= y + height;

if (highlighted && mouse_check_button_pressed(mb_left)) {
    publish(on_click_event, level_data);
}