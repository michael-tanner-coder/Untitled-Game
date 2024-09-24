    if (input_check_pressed(skip_input_key)) {
        go_to_next_scene();
    }
    
    if (input_check_pressed(progress_input_key) && dialogue_box.page_finished) {
        go_to_next_scene();
    }