// Enemies
function spawn_enemy(_enemy_type, _x = 0, _y = 0) {
    instance_create_layer(_x, _y, "Instances", _enemy_type);
}

function destroy_all_enemies() {
    
    FOREACH global.enemy_list ELEMENT
        with (_elem) {
            instance_destroy(self);
        }
    END
    
}

function flip_over_all_enemies() {
    FOREACH global.enemy_list ELEMENT
        with (_elem) {
            change_state(ACTOR_STATE.FLIPPED);
        }
    END
}

// Score
function set_score(_score) {
    
    if (!is_numeric(_score) || _score < 0) {
        return;
    }
    
    with (obj_game_manager) {
        level_score = _score;
    }
    
}

function reset_score() {
    
     with (obj_game_manager) {
        level_score = 0;
    }
    
}


// Time
function set_time(_time) {
    
     if (!is_numeric(_time)) {
        return;
    }
    
    with (obj_game_manager) {
        timer = _time;
    }
    
}

function reset_time() {
    
     with (obj_game_manager) {
        timer = max_timer;
    }
    
}

function initiate_time_warning() {
    
     with (obj_game_manager) {
        timer = warning_time;
    }
    
}

function initiate_time_alert() {
    
     with (obj_game_manager) {
        timer = alert_time;
    }
    
}