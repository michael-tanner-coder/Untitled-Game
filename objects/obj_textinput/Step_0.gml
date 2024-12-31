if (disabled) {
    return;
}

// cap input string to character limit
if (string_length(keyboard_string) > input_character_limit) {
     keyboard_string = string_copy(keyboard_string, 1, input_character_limit);
}

// only update string when component is in focus
if (focused) {
    input_string = keyboard_string;
}

typist.in(max(string_length(input_string)-1, 1), 100);

// flicker cursor at the end of the typed string
flicker_time--;
flicker_time = loop_clamp(flicker_time, -max_flicker_time, max_flicker_time);
