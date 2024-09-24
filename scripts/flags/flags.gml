function get_flag(_flag = "") {
    
    if (!is_string(_flag)) {
        show_debug_message("Error: Provided flag name is not a string");
        return undefined;
    }
    
    var _save_data = loadFromJson(global.save_file);
    
    var _flags = _save_data.flags;
    
    var _flag_to_get = struct_get(_flags, _flag);
    
    return _flag_to_get;
    
}

function set_flag(_flag = "", _value = true) {

    if (!is_bool(_value)) {
        show_debug_message("Error: Provided value is not a boolean");
        return undefined;
    }
    
    if (!is_string(_flag)) {
        show_debug_message("Error: Provided flag name is not a string");
        return undefined;
    }
    
    var _save_data = loadFromJson(global.save_file);
    
    var _flags = _save_data.flags;
    
    struct_set(_flags, _flag, _value);
    
    saveToJson(_save_data, global.save_file);
    
}

function reset_all_flags() {
    
    var _save_data = loadFromJson(global.save_file);
    
    var _flags = _save_data.flags;
    
    var keys = variable_struct_get_names(_flags);
    
    for (var _i = array_length(keys)-1; _i >= 0; --_i) {
        var _key = keys[_i];
        struct_set(_flags, _key, false);
    }
    
    saveToJson(_save_data, global.save_file);
    
}