// TODO:
// Deck Create/Edit:
// save/edit decks when confirming changes

// Edit/Create Mode
mode = "edit";
deck_data = global.active_deck;

// Dimensions/Positioning
column_limit = 3;
starting_x = x;
starting_y = y;
record_margin_x = 20;
record_margin_y = 10;

// Objects
record_object = obj_card_grid_item;
page_counter = undefined;
tooltip = undefined;

// Pagination
current_page = 0;
page_count = 1;
pages = [];
records_per_page = 9;
records = global.collection;

// Transition animation
transition_effect_object = obj_wipe_transition;
transition_effect_instance = undefined;

// Methods
paginate_data = function() {
    var _total_record_count = array_length(records);
    var _record_count = 0;
    var _new_page = [];
    
    page_count = ceil(_total_record_count / records_per_page);
    
    // reversing the array so that the latest cards are shown first
    FOREACH array_reverse(records) ELEMENT
        var _record = _elem;
        
        show_debug_message("key")
        show_debug_message(_elem.key)
        show_debug_message("id")
        show_debug_message(_elem.id)
        
        if (_record_count == records_per_page) {
            array_push(pages, _new_page);
            _new_page = [];
            _record_count = 0;
        }
        
        if (_record_count < records_per_page) {
            _record_count += 1;
            array_push(_new_page, _record);
        }
    END
    
    if (array_length(pages) < page_count) {
        array_push(pages, _new_page);
    }
}

spawn_record_objects = function() {
    show_debug_message("SPAWN RECORD OBJECTS");
    if (array_length(pages) == 0) {
        return;
    }
    
    var _records = pages[current_page];
    var _column_count = 0;
    var _x = starting_x;
    var _y = starting_y;
    
    show_debug_message("RECORD COUNT:");
    show_debug_message(string(array_length(_records)));
    
    FOREACH _records ELEMENT
        // Spawn record object with data passed as a param
        var _record_data = _elem;
        var _card_data = variable_clone(get_upgrade_type(_record_data.key));
        var _record_object  = instance_create_layer(starting_x, starting_y, layer, record_object);
        _record_object.card_data = struct_merge(_card_data, _record_data, false);
        show_debug_message("KEY");
        show_debug_message(_record_object.card_data.key);
        show_debug_message("ID");
        show_debug_message(_record_object.card_data.id);
        
        // Find grid position for record object; adjust when we exceed column limit
        if (_column_count > 0) {
            _x += (sprite_get_width(_record_object.sprite_index) + record_margin_x); 
        }
        
        // Track column count so that we know when we've exceeded the column limit 
        _column_count += 1;
        if (_column_count > column_limit) {
            _column_count = 1;
            _y += sprite_get_height(_record_object.sprite_index) + record_margin_y;
            _x = starting_x;
        }
        
        _record_object.x = _x;
        _record_object.y = _y;
    END
}

refresh_ui = function() {
    
    with(record_object) {
        instance_destroy(self);
    }

    spawn_record_objects();
}

go_to_next_page = function() {
    current_page = min(current_page + 1, page_count-1);
    refresh_ui();
}

go_to_previous_page = function() {
    current_page = max(current_page - 1, 0);
    refresh_ui();
}

spawn_ui_objects = function() {
    var _grid_width = column_limit * (sprite_get_width(object_get_sprite(record_object)) + record_margin_x);
    var _left_button = instance_create_layer(starting_x - sprite_get_width(spr_arrow_button_left_normal) - record_margin_x, room_height/2, layer, obj_button);
    var _right_button = instance_create_layer(starting_x + _grid_width, room_height/2, layer, obj_button);
    var _confirm_button = instance_create_layer(x, y, layer, obj_button);

    _left_button.sprite_index = spr_arrow_button_left_normal;
    _left_button.sprite = spr_arrow_button_left_normal;
    _left_button.normal_sprite = spr_arrow_button_left_normal;
    _left_button.highlight_sprite = spr_arrow_button_left_highlighted;
    _left_button.pressed_sprite = spr_arrow_button_left_pressed;
    _left_button.on_click_event = "prev_page";
    _left_button.use_nine_slice = false;
    _left_button.button_id = "left_button";

    _right_button.sprite_index = spr_arrow_button_right_normal;
    _right_button.sprite = spr_arrow_button_right_normal;
    _right_button.normal_sprite = spr_arrow_button_right_normal;
    _right_button.highlight_sprite = spr_arrow_button_right_highlighted;
    _right_button.pressed_sprite = spr_arrow_button_right_pressed;
    _right_button.on_click_event = "next_page";
    _right_button.use_nine_slice = false;
    _right_button.button_id = "right_button";
    
    _confirm_button.on_click_event = "open_name_modal";
    _confirm_button.text = "CONFIRM";
    _confirm_button.x = VIEW_WIDTH/2 - _confirm_button.width/2;
    _confirm_button.y = room_height - 135;
    _confirm_button.button_id = "confirm_button";

    page_counter = instance_create_layer(room_width/2, room_height - 165, layer, obj_page_count);
    page_counter.page_count =  page_count;
    page_counter.current_page = current_page;
    
    tooltip = instance_create_layer(-1000, -1000, layer, obj_tooltip);
    tooltip.header = "HEADER";
    tooltip.text = "Description";
    tooltip.depth = depth - 10;
}

center_grid = function() {
    starting_x = room_width/2;
    
    var _grid_width = (column_limit * sprite_get_width(object_get_sprite(record_object))) + ((column_limit-1) * record_margin_x);
    
    starting_x -= _grid_width/2;
}

// Event Subscriptions
subscribe(id, "next_page", function() {
    go_to_next_page();
});

subscribe(id, "prev_page", function() {
    go_to_previous_page();
});

subscribe(id, "open_name_modal", function() {
    fsm.change("name_input");
});

subscribe(id, "close_name_modal", function() {
     fsm.change("editing");
});

subscribe(id, "select_card", function(_payload = {}) {
    var _card_data = _payload.card_data;
    var _card_instance = _payload.card_instance;
    _card_instance.selected = true;

     if (is_in_deck(_card_data, deck_data.cards)) {
        remove_from_deck(_card_data, deck_data.cards);
        play_sound(snd_button_click);
    } else {
        add_to_deck(_card_data, deck_data.cards);
        play_sound(snd_button_back);
    }
});

subscribe(id, "confirm_changes", function() {
    // Pull deck name
    var _deck_name = "";
    with(obj_textinput) {
        if (input_id == "name_input") {
            _deck_name = input_string;
        }
    }
    
    // Create deck save payload
    if (_deck_name != "") {
        deck_data.name = _deck_name;
    }
    
    // Save changes
    save_deck(deck_data);
   
    // Return to deck selection menu
    go_to_scene_by_key("deck-selection");
});

// Init
paginate_data();
center_grid();
spawn_record_objects();
spawn_ui_objects();

// State Machine
fsm = new SnowState("editing");

fsm.add("editing", {
    enter: function() {
        keyboard_string = "";
        
        with(obj_textinput) {
            instance_destroy(self);
        }
        
        with(record_object) {
            disabled = false;
        }
        
        var _button_ids = ["confirm_button", "left_button", "right_button"];
        with(obj_button) {
            if (button_id == "cancel_name" || button_id == "confirm_name") {
                instance_destroy(self);
            }
            
            if (array_contains(_button_ids, button_id)) {
                disabled = false;
            }
        }
    },
    step: function() {
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
    },
    draw: function() {},
});

fsm.add("name_input", {
    enter: function() {
        // Disabled existing UI inputs
        with(record_object) {
            disabled = true;
        }
        
        var _button_ids = ["confirm_button", "left_button", "right_button"];
        with(obj_button) {
            if (array_contains(_button_ids, button_id)) {
                disabled = true;
            }
        }
        
        // UI Inputs
        var _textinput = instance_create_layer(200, VIEW_HEIGHT/2 - 100, layer, obj_textinput);
        var _confirm_button = instance_create_layer(_textinput.x, _textinput.y + string_height("W"), layer, obj_button);
        var _cancel_button = instance_create_layer(_textinput.x + _confirm_button.width + 32, _textinput.y + string_height("W"), layer, obj_button);
        
        _textinput.input_character_limit = 10;
        _textinput.input_id = "name_input";
        _textinput.input_string_x = _textinput.x;
        _textinput.input_string_y = _textinput.y;
        _textinput.depth = depth - 1;
        
        _confirm_button.button_id = "confirm_name";
        _confirm_button.text = "CONFIRM";
        _confirm_button.on_click_event = "confirm_changes";
        _confirm_button.depth = depth - 1;
        
        _cancel_button.button_id = "cancel_name";
        _cancel_button.text = "CANCEL";
        _cancel_button.on_click_event = "close_name_modal";
        _cancel_button.depth = depth - 1;
        
        // Change input text based on mode
        if (mode == "edit") {
            _textinput.input_string = deck_data.name;
            keyboard_string = _textinput.input_string;
        }
    },
    step: function() {},
    draw: function() {
        draw_set_alpha(0.5);
        draw_set_color(BLACK);
        draw_rectangle(0, 0, VIEW_WIDTH, VIEW_HEIGHT, false);
        draw_set_alpha(1);
    },
});