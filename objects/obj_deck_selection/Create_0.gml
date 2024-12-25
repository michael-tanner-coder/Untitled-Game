// paginate the grid menu (fix size of page count component; fix off-by-one error)
// re-align UI elements (fix large hitbox of arrow buttons)

// Dimensions/Positioning
column_limit = 3;
starting_x = x;
starting_y = y;
record_margin_x = 10;
record_margin_y = 10;

// Objects
record_object = obj_deck;
page_counter = undefined;

// Pagination
current_page = 0;
page_count = 1;
pages = [];
records_per_page = 4;
records = global.available_decks;

// Transition animation
transition_effect_object = obj_wipe_transition;
transition_effect_instance = undefined;

// Methods
paginate_data = function() {
    var _total_record_count = array_length(records);
    var _record_count = 0;
    var _new_page = [];
    
    page_count = ceil(_total_record_count / records_per_page);
    
    FOREACH records ELEMENT
        var _record = _elem;
        
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
    var _records = pages[current_page];
    var _column_count = 0;
    var _x = starting_x;
    var _y = starting_y;
    
    show_debug_message("RECORD COUNT:");
    show_debug_message(string(array_length(_records)));
    
    FOREACH _records ELEMENT
        // Spawn record object with data passed as a param
        var _record_data = _elem;
        var _record_object  = instance_create_layer(starting_x, starting_y, layer, record_object);
        _record_object.deck_data = _record_data;
        
        // Find grid position for record object; adjust when we exceed column limit
        if (_column_count > 0) {
            _x += (sprite_get_width(_record_object.sprite_index) + record_margin_x); 
        }
        
        // Track column count so that we know when we've exceeded the column limit 
        _column_count += 1;
        if (_column_count > column_limit) {
            _column_count = 0;
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
    var _confirm_button = instance_create_layer(room_width/2 - sprite_get_width(spr_button_normal)/2, room_height - 100, layer, obj_button);
    
    _left_button.sprite = spr_arrow_button_left_normal;
    _left_button.normal_sprite = spr_arrow_button_left_normal;
    _left_button.highlight_sprite = spr_arrow_button_left_highlighted;
    _left_button.pressed_sprite = spr_arrow_button_left_pressed;
    _left_button.on_click_event = "prev_page";
    _left_button.use_nine_slice = false;

    _right_button.sprite = spr_arrow_button_right_normal;
    _right_button.normal_sprite = spr_arrow_button_right_normal;
    _right_button.highlight_sprite = spr_arrow_button_right_highlighted;
    _right_button.pressed_sprite = spr_arrow_button_right_pressed;
    _right_button.on_click_event = "next_page";
    _right_button.use_nine_slice = false;
    
    _confirm_button.on_click_event = "start_run";
    _confirm_button.text = "CONFIRM";

    page_counter = instance_create_layer(room_width/2, room_height - 150, layer, obj_page_count);
    page_counter.page_count =  page_count;
    page_counter.current_page = current_page;
}

// Event Subscriptions
subscribe(id, "next_page", function() {
    go_to_next_page();
});
subscribe(id, "prev_page", function() {
    go_to_previous_page();
});
subscribe(id, "start_run", function() {
    fsm.change("confirmation");
});
subscribe(id, "select_deck", function(_payload = {}) {
    var _deck_data = _payload.deck_data;
    var _deck_instance = _payload.deck_instance;
    global.active_deck = _deck_data;
    with (obj_deck) {
        selected = false;
    }
    _deck_instance.selected = true;
});

// Init
paginate_data();
spawn_record_objects();
spawn_ui_objects();

// State Machine
fsm = new SnowState("selection");

fsm.add("selection", {
    enter: function() {},
    step: function() {},
    draw: function() {},
});

fsm.add("confirmation", {
    enter: function() {
        transition_effect_instance = instance_create_layer(x, y, "UI_Instances", transition_effect_object);
    	transition_effect_instance.starting_x = -1 * sprite_get_width(transition_effect_instance.sprite_index);
    	transition_effect_instance.target_x = -1 * transition_effect_instance.x_buffer
    	transition_effect_instance.start_animation();
    },
    step: function() {
        if (transition_effect_instance.animation_progress >= 1) {
            go_to_scene_by_key("level");
        }
    },
    draw: function() {},
});