level_data = [
        level_struct("level_1", "Jack Arena", undefined, 0, "basic_set", 0, 40000),
        level_struct("level_2", "Queen Arena", undefined, 0, "advanced_set", 0, 80000),
        level_struct("level_3", "King Arena", undefined, 0, "pro_set", 0, 160000),
        level_struct("level_4", "Joker Arena", undefined, 0, "final_set", 0, 320000),
];
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

    END
}

spawn_level_menu_items();