function unlock_character(_new_character = 0) {
    
    if (!is_numeric(_new_character)) {
        show_debug_message("Error: Provided character ID is not a number");
        return;
    }
    
    var _save_data = loadFromJson(global.save_file);
    
    if (array_contains(_save_data.characters, _new_character)) {
        return;
    }
    
    array_push(_save_data.characters, _new_character);
    
    saveToJson(_save_data, global.save_file);
    
}


function character_is_unlocked(_character = 0) {
	
    if (!is_numeric(_character)) {
        show_debug_message("Error: Provided character ID is not a number");
        return;
    }
    
     var _save_data = loadFromJson(global.save_file);
    
    return array_contains(_save_data.characters, _character);
	
}


function reset_characters() {
    
    var _save_data = loadFromJson(global.save_file);
    
    _save_data.characters = [CHARACTER.NORMAL];
    
    saveToJson(_save_data, global.save_file);
    
}

