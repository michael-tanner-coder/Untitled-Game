
global.unlock_map = {
    upgrades: init_upgrades_collection(),
    levels: init_levels_collection(),
};

function unlock_struct(_key = "", _category = "", _points = 0) {
    return {
        key: _key,
        category: _category,
        required_points: _points,
    }
}

global.default_unlock_progress = {
     level_1: {
        current_points: 0,
        required_points: 2000,
        max_points: 40000,
      },
      level_2: {
        current_points: 0,
        required_points: 4000,
        max_points: 80000,
      },
      level_3: {
        current_points: 0,
        required_points: 8000,
        max_points: 160000,
      },
      level_4: {
        current_points: 0,
        required_points: 16000,
        max_points: 320000,
      }
};
global.unlock_progress = get_save_data_property(UNLOCK_PROGRESS_POINTS, global.default_unlock_progress);

global.unlockables = [
    unlock_struct("fire_faster", "upgrades", 1000),
    unlock_struct("move_faster", "upgrades", 1200),
    unlock_struct("get_sturdy", "upgrades", 1300),
    unlock_struct("bullet_strength", "upgrades", 1400),
    unlock_struct("shot_spread", "upgrades", 8000),
    unlock_struct("shot_focus", "upgrades", 9000),
    unlock_struct("steady_fire", "upgrades", 16000),
    unlock_struct("fast_fire", "upgrades", 17000),
    unlock_struct("bullet_strength", "upgrades", 20000),
    unlock_struct("extra_life", "upgrades", 22000),
    unlock_struct("closer", "upgrades", 30000),
    unlock_struct("revive", "upgrades", 60000),
];

function get_unlock_data(_key = "") {
    var _unlock = undefined;
    
    FOREACH global.unlockables ELEMENT
        if (_elem.key == _key) {
            _unlock = _elem;
            break;
        }
    END
    
    return _unlock;
}

function unlock_random_card() {
    var _card = get_random_element(global.unlockables);
    unlock_item(_card);
    global.most_recent_unlock = _card.key;
    return _card;
}

function unlock_card(_card_key = "") {
    var _card = get_unlock_data(_card_key);
    unlock_item(_card);
    global.most_recent_unlock = _card_key;
    return _card;
}

function unlock_next_item(_score = 0) {
    FOREACH global.unlockables ELEMENT
        var _unlockable = _elem;
        
        if (!is_unlocked(_unlockable) && _score >= _unlockable.required_points) {
            unlock_item(_unlockable);
            global.most_recent_unlock = _unlockable.key;
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
    set_save_data_property("upgrades", global.default_unlocked_upgrades);
    set_save_data_property("levels", global.default_unlocked_levels);
    set_save_data_property(UNLOCK_PROGRESS_POINTS, global.default_unlock_progress);
    global.unlock_progress = get_save_data_property(UNLOCK_PROGRESS_POINTS, global.default_unlock_progress);
}
