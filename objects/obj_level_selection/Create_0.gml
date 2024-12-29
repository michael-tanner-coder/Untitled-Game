level_data = global.levels;
level_object = obj_level_menu_item;
starting_y = HEADER_HEIGHT;

colors = [GREEN, BLUE, YELLOW, RED];

spawn_level_menu_items = function() {
    var _x = 0;
    var _y = starting_y;
    FOREACH level_data ELEMENT
        var _level_data = _elem;
        var _level_menu_item = instance_create_layer(_x, _y, layer, level_object);
        _level_menu_item.level_data = _level_data;
        _level_menu_item.color = colors[_i];
        _level_menu_item.width = VIEW_WIDTH;
        _level_menu_item.height = (VIEW_HEIGHT - HEADER_HEIGHT) / array_length(level_data);
        _y += _level_menu_item.height;
        
        // check if level is unlocked
        var _key = struct_get(_level_data, "key");
        var _unlocked = is_unlocked({category: "levels", key: _key });
        _level_menu_item.unlocked = _unlocked;
        
        // get card collection data for each level
        var _card_set = struct_get(_level_data, "card_set");
        var _card_set_data = get_card_set_struct(_card_set);
        var _cards = struct_get(_card_set_data, "cards");
    
        _level_menu_item.card_set_total = array_length(_cards);
        var _unlocked_card_count = 0;
        for (var _j = 0; _j < array_length(_cards); _j++) {
            if (is_unlocked({category: "upgrades", key: _cards[_j]})) {
                _unlocked_card_count += 1;
            }
        }
        _level_menu_item.cards_collected =  _unlocked_card_count;
        
        // get card unlock progress for each level
        _level_menu_item.card_unlock_progress = global.unlock_progress[$ _key];
        _level_menu_item.card_unlock_progress_limit = global.required_points[$ _key];
    END
}

spawn_level_menu_items();

// Event Subscriptions
subscribe(id, "level_selected", function(_level = {}) {
    show_debug_message("LEVEL SELECTED");
    show_debug_message(_level);
    global.chosen_level = _level.key;
    go_to_scene_by_key("deck-selection");
});