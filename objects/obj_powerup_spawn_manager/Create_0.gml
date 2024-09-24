
max_spawn_timer = 5 * room_speed;
spawn_timer = max_spawn_timer;
spawning_inactive = true;
previous_spawn_type = "";

spawn_powerup = function() {
    if (array_length(global.powerups_spawn_list) == 0) {
        return;
    }
    
    
    // pick random powerup; don't select same one twice in a row, unless we only have 1 to choose from
    var _powerup_type = {key: ""};
    if (array_length(global.powerups_spawn_list) == 1) {
        _powerup_type = global.powerups_spawn_list[0];
    }
    else {
        do {
            _powerup_type = global.powerups_spawn_list[irandom_range(0, array_length_1d(global.powerups_spawn_list)-1)];
        } until(_powerup_type.key != previous_spawn_type)
    }
    
    // spawn randomly picked powerup
    var _powerup = instance_create_layer(x,y, layer, obj_powerup);
    _powerup.collect_events = _powerup_type.effects;
    _powerup.sprite_index = _powerup_type.sprite;
    _powerup.speed *= _powerup_type.speed_factor;
    previous_spawn_type = _powerup_type.key;
}

subscribe(id, ACTORS_ACTIVATED, function() {
    spawning_inactive = false;
});

subscribe(id, ACTORS_DEACTIVATED, function() {
    spawning_inactive = true;
});

subscribe(id, ACTIVATED_POWERUP, function() {
    spawning_inactive = true;
});

subscribe(id, DEACTIVATED_POWERUP, function() {
    spawning_inactive = false;
});