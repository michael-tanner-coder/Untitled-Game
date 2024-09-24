function powerup_struct(_key="", _name="", _description="", _speed_factor=1, _price=0, _sprite=undefined, _effects=[]) {
    return {
        key: _key,
        name: _name,
        description: _description,
        speed_factor: _speed_factor,
        price: _price,
        sprite: _sprite,
        effects: _effects,
    }
}

global.powerup_types = [
    powerup_struct(
        "score", 
        "BONUS POINTS", 
        "Gives you 300 bonus points", 
        1, 
        1000, 
        spr_powerup_bubble_score, 
        [GAINED_EXTRA_POINTS]
    ),
];
global.default_unlocked_powerups = ["score"];

FOREACH global.powerup_types ELEMENT
    unlock_item({key: _elem, category: "powerups"});
END

global.max_powerups_list_size = 3;
global.powerups_spawn_list = [];

function get_powerup_type(_key = "") {
     if (!is_string(_key)) {
        show_debug_message("Error: the provided key is not a string");
        return;
    }
    
    var _matching_powerup = undefined;
    FOREACH global.powerup_types ELEMENT
        var _powerup = _elem;
        if (_powerup.key == _key) {
            _matching_powerup =  _powerup;
        }
    END
    
    return _matching_powerup;
}

function add_powerup_to_spawn_list(_key = "") {
    if (!is_string(_key)) {
        show_debug_message("Error: the provided key is not a string");
        return;
    }
    
    var _powerup = get_powerup_type(_key);
    
    if (array_length(global.powerups_spawn_list) < global.max_powerups_list_size && !array_contains(global.powerups_spawn_list, _powerup)) {
        array_push(global.powerups_spawn_list, _powerup);
    }
}

function remove_powerup_from_spawn_list(_key = "") {
    if (!is_string(_key)) {
        show_debug_message("Error: the provided key is not a string");
        return;
    }
    
    var _powerup = get_powerup_type(_key);
    
    if (array_length(global.powerups_spawn_list) > 0) {
        var _index = undefined;
        
        FOREACH global.powerups_spawn_list ELEMENT
            var _powerup = _elem;
            if (_powerup.key == _key) {
                _index = _i;
            }
        END
        
        if (_index != undefined) {
            array_delete(global.powerups_spawn_list, _index, 1);
        }
    }
}

function get_powerup_from_spawn_list(_key = "") {
    if (!is_string(_key)) {
        show_debug_message("Error: the provided key is not a string");
        return;
    }
    
    var _matching_powerup = undefined;
    
    FOREACH global.powerups_spawn_list ELEMENT
        var _powerup = _elem;
        if (_powerup.key == _key) {
            _matching_powerup = _powerup;
        }
    END
    
    return _matching_powerup;
}

