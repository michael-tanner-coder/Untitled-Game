global.unlock_map = {
    cosmetics: global.cosmetics,
    lab_logs: global.lab_logs,
    powerups: global.powerup_types,
};

function unlock_struct(_key = "", _category = "", _points = 0) {
    return {
        key: _key,
        category: _category,
        required_points: _points,
    }
}

global.unlock_progress = get_save_data_property("unlock_progress", 0);


global.unlockables = [
    unlock_struct("enemy_bonus", "powerups", 1000),
    unlock_struct("key_bonus", "powerups", 2000),
    unlock_struct("topHat", "cosmetics", 3000),
    unlock_struct("life", "powerups", 5000),
    unlock_struct("slowdown_field", "powerups", 4000),
    unlock_struct("freeze_enemies", "powerups", 4000),
    unlock_struct("exploding_enemies", "powerups", 2000),
    unlock_struct("topHat", "cosmetics", 4000),
    unlock_struct("bowlerHat", "cosmetics", 8000),
    unlock_struct("cowboyHat", "cosmetics", 5000),
];

function unlock_next_item(_score = 0) {
    FOREACH global.unlockables ELEMENT
        var _unlockable = _elem;
        
        if (!is_unlocked(_unlockable) && _score >= _unlockable.required_points) {
            unlock_item(_unlockable);
            break;
        }
    END
}

function unlock_item(_unlockable = {}) {
    var _category = _unlockable.category;
    var _key = _unlockable.key;
    
    var _save_data = loadFromJson(global.save_file);
    
    if (is_unlocked(_unlockable)) {
        return;
    }
    
    if (!is_array(struct_get(_save_data, _category))) {
        _save_data[$_category] = [];
    }
    
    array_push(_save_data[$_category], _key);
    
    saveToJson(_save_data, global.save_file);
}

function get_next_unlock() {
    var _next_unlock = undefined;
    
    FOREACH global.unlockables ELEMENT
        if (!is_unlocked(_elem) && _next_unlock == undefined) {
            _next_unlock = _elem;
        }
    END
    
    return _next_unlock;
}

function get_unlock_item_data(_unlockable) {
    var _category = _unlockable.category;
    var _collection = global.unlock_map[$_category];
    
    var _item_data = undefined;
    if (is_array(_collection)) {
        FOREACH _collection ELEMENT
            if (_elem.key == _unlockable.key) {
                _item_data = _elem;            
            }
        END
    }
    
    return _item_data;
}

function is_unlocked(
    _unlockable = {
        category: "",
        key: ""
    }
) {
    var _category = _unlockable.category;
    var _key = _unlockable.key;
    var _save_data = loadFromJson(global.save_file);
    var _collection = get_save_data_property(_category, []);
    
    return is_array(_collection) && array_contains(_collection, _key);
}

function reset_unlocks() {
    set_save_data_property("unlock_progress", 0);
    set_save_data_property("cosmetics", []);
    set_save_data_property("lab_logs", []);
    set_save_data_property("powerups", []);
}