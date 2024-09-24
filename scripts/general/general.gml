function get_save_data_property(_property = "", _default_value = 0) {
    var _save_data = loadFromJson(global.save_file);
    var _value = struct_get(_save_data, _property);
    
    // return the value as-is if present in the save file
    if (is_struct(_save_data) && _value != undefined) {
        return _value;
    }
    
    // populate the property with the default value if it does not currently exist in the save file
    _save_data[$_property] = _default_value;
    saveToJson(_save_data, global.save_file);
}

function set_save_data_property(_property = "", _value = 0) {
    var _save_data = loadFromJson(global.save_file);
    _save_data[$_property] = _value;
    saveToJson(_save_data, global.save_file);
}