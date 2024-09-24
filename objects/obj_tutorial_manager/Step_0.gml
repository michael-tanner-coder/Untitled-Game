// don't run any step code if no tutorial prompt is available
if (!current_prompt || tutorial_ended) {
    return;
}

var _is_last_prompt = prompt_index >= array_length(tutorial_sequence.prompts) - 1;

var _typing_finished = typist.get_state() == 1;
if (_typing_finished) {
    prompt_typing_finished = true;
}

// check if we have pressed any valid inputs for this tutorial prompt
var _prompt_inputs = struct_get(current_prompt, "inputs");
if (prompt_typing_finished && is_array(_prompt_inputs)) {
    FOREACH current_prompt.inputs ELEMENT
        var _prompt_input = _elem;
        if (input_check_pressed(_prompt_input)) {
            current_prompt_count += 1;
            
            var _prompt_count = struct_get(current_prompt, "count");
            if (current_prompt_count <= _prompt_count && is_numeric(_prompt_count)) {
                init_success_animation();
            }
        }
    END
}

if (non_tutorial && prompt_typing_finished && is_array(_prompt_inputs)) {
    FOREACH current_prompt.inputs ELEMENT
        var _prompt_input = _elem;
        if (input_check_pressed(_prompt_input)) {
            var _prompt_count = struct_get(current_prompt, "count");
            if (!is_numeric(_prompt_count)) {
                typist.skip();
            }
            
             var _prompt_count = struct_get(current_prompt, "count");
             if (!is_numeric(_prompt_count)) {
                go_to_next_prompt();
            }
        }
    END
}

if (non_tutorial && !prompt_typing_finished && is_array(_prompt_inputs)) {
    FOREACH current_prompt.inputs ELEMENT
        var _prompt_input = _elem;
        if (input_check_pressed(_prompt_input)) {
            var _prompt_count = struct_get(current_prompt, "count");
            if (!is_numeric(_prompt_count)) {
                typist.skip();
            }
        }
    END
}



// advance to next prompt if we have made the correct input the required number of times
var _prompt_count = struct_get(current_prompt, "count");
if (is_numeric(_prompt_count) && current_prompt_count >= _prompt_count) {
    current_prompt_count = min(current_prompt_count, _prompt_count);
    next_prompt_ready = true;
}

// advance to the next prompt if time has run out
var _time = struct_get(current_prompt, "time");
if (is_numeric(_time)) {
    current_prompt_time--;
    if (current_prompt_time <= 0) {
        next_prompt_ready = true;
    }
}

// immediately end tutorial if this prompt was the last one in the sequence
if (next_prompt_ready && _is_last_prompt) {
    go_to_next_prompt();
    next_prompt_ready = false;
}

// otherwise, wait to move to the next prompt
if (next_prompt_ready) {
    next_prompt_timer--;
}

if (next_prompt_timer <= 0) {
    go_to_next_prompt();
    next_prompt_ready = false;
    next_prompt_timer = 100;
}

text_animation_time--;
text_animation_time = max(text_animation_time, 0);