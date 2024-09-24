function unlock_level(_level = "") {
    
    if (!is_string(_level)) {
        show_debug_message("Error: Provided level key is not a string");
        return;
    }
    
    var _save_data = loadFromJson(global.save_file);
    
    var _levels = _save_data.unlocked_levels;
    
    if (array_contains(_levels, _level)) {
        show_debug_message("Error: Provided level is already unlocked");
        return;
    }
    
    array_push(_levels, _level);
    
    saveToJson(_save_data, global.save_file);
    
}

function reset_unlocked_levels() {
    
    var _save_data = loadFromJson(global.save_file);
    
    _save_data.unlocked_levels = [];
    
    saveToJson(_save_data, global.save_file);
    
}