tutorial_sequence = undefined;
current_prompt = undefined;
current_prompt_count = 0;
current_prompt_time = 0;
prompt_index = 0;
tutorial_ended = false;
next_prompt_timer = 100;
next_prompt_ready = false;
padding_x = 20;
padding_y = 20;
prompt_typing_finished = false;
text_animation_time = 0;
non_tutorial = false;

// scribble effects
typist = scribble_typist();
typist.in(0.5, 20);
typist.sound_per_char([snd_speak_med_7], 0.75, 1.25);
typist.ease(SCRIBBLE_EASE.ELASTIC, 0, 20, 1, 1, 0, 1);
textbox_width = 450;
textbox_height = 300;

scribble_color_set("YELLOW", YELLOW);
scribble_color_set("GREEN", GREEN);
scribble_color_set("PINK", PINK);
scribble_color_set("WHITE", WHITE);
scribble_color_set("ORANGE", ORANGE);

function subscribe_to_tutorial_events(_tutorial_prompt) {
    var _events = struct_get(_tutorial_prompt, "events");
    if (is_array(_events)) {
        FOREACH _events ELEMENT
            var _event = _elem;
            subscribe(id, _event, function() {
                if (prompt_typing_finished) {
                    current_prompt_count += 1;
                    init_success_animation();
                }
            });
        END
    }
}

function unsubscribe_from_tutorial_events(_tutorial_prompt) {
    var _events = struct_get(_tutorial_prompt, "events");
    if (is_array(_events)) {
        FOREACH _events ELEMENT
            var _event = _elem;
            unsubscribe(id, _event);
        END
    }
}

function publish_tutorial_prompt_events(_tutorial_prompt, _event_list_key = "") {
    var _entrance_events = struct_get(_tutorial_prompt, _event_list_key);
    
    if (is_array(_entrance_events)) {
        FOREACH _entrance_events ELEMENT
            var _event_string = _elem;
            var _event_array = string_split(_event_string, " ");
            var _event_name = _event_array[0];
            var _event_data = [];
            
            for (var _j = 1; _j <= array_length(_event_array) - 1; _j++) {
                array_push(_event_data, _event_array[_j]);
            }
            
            publish(_event_name, _event_data);
        END
    }
}

start_tutorial = function() {
    var _scene = get_current_scene();
    if (_scene) {
        var _tutorial_flag = struct_get(_scene, "tutorial_flag");
        tutorial_sequence = get_tutorial_sequence(_tutorial_flag);
        if (tutorial_sequence) {
            current_prompt = struct_get(tutorial_sequence, "prompts")[0];
            
            publish_tutorial_prompt_events(current_prompt, "on_enter_events");
            
            var _time = struct_get(current_prompt, "time");
            if (is_numeric(_time)) {
                current_prompt_time = _time;
            }
            
           subscribe_to_tutorial_events(current_prompt);
        }
    }
}

function go_to_next_prompt() {
    prompt_index += 1;
    current_prompt_count = 0;
    current_prompt_time = 0;
    prompt_typing_finished = false;
    
    publish_tutorial_prompt_events(current_prompt, "on_exit_events");
    unsubscribe_from_tutorial_events(current_prompt);
    
    if (prompt_index <= array_length(tutorial_sequence.prompts) - 1) {
        current_prompt = tutorial_sequence.prompts[prompt_index];
        
        publish_tutorial_prompt_events(current_prompt, "on_enter_events");
        
        var _time = struct_get(current_prompt, "time");
        if (is_numeric(_time)) {
            current_prompt_time = _time;
        }
        
        subscribe_to_tutorial_events(current_prompt);
    }
    else {
        tutorial_ended = true;
        set_flag(tutorial_sequence.flag, true);
    }
}

function init_success_animation() {
    scribble_anim_pulse(0.4, 0.1);
    text_animation_time = 40;
    play_sound(snd_tutorial_success);
}

subscribe(id, TUTORIAL_STARTED, start_tutorial);
subscribe(id, TUTORIAL_ENDED, function() {
    tutorial_ended = true;
});
subscribe(id, FINISHED_SCENE, function() {
    go_to_next_scene();
})