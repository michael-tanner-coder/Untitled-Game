
// Get current scene data and initialize character queue
var _scene = get_current_scene();

var _available_characters = struct_get(_scene, "available_characters");
if (is_array(_available_characters)) {
	set_character_queue(_available_characters);
}
else {
	load_character_queue();
}

// base level properties
max_timer = STANDARD_TIME_LIMIT;
timer = max_timer;
warning_time = 30;
alert_time = 10;
collected_keys = 0;
goal_key_count = 18;
phase = 1;
max_phase = 3;
win_condition = "keys";
enemy_types = [];
multiplier = 1;
max_multiplier = 5;
no_lives_lost = true;
enemies_defeated = 0;
multiplier_timer = 60;
music_tracks = undefined;
first_alert = false;
second_alert = false;
countdown_sequence = undefined;
is_tutorial_scene = false;
key_bonus = 0;
enemy_bonus = 0;
max_powerup_timer = 600;
powerup_timer = 0;
powerup_active = false;

global.best_score = 0;
show_debug_message("TUTORIAL FLAG:");
show_debug_message(get_flag("needs_tutorial"));
global.tutorial = get_flag("needs_tutorial");
score = 0;
cursor_sprite = spr_reticle;
window_set_cursor(cr_none);
window_set_caption("I don't know what to call this yet");

base_score = {
	label: "POINTS GAINED",
	tally: undefined,
	points: 0,
	current_points: 0,
	current_x: -1000, 
};

no_lives_lost = {
    label: "NO LIVES LOST",
	tally: undefined,
	points: 0,
	current_points: 0,
	current_x: -1000, 
	achieved: true,
};

time_bonus = {
	label: "TIME BONUS",
	tally: 0,
	points: 0,
	current_points: 0,
	current_x: -1000, 
};

monster_bonus = {
    label: "ENEMIES DEFEATED",
	tally: 0,
	points: 0,
	current_points: 0,
	current_x: -1000, 
};

total = {
    label: "TOTAL SCORE",
	tally: undefined,
	points: 0,
	current_points: 0,
	current_x: -1000, 
};

final_score = {
	label: "FINAL SCORE", 
	tally: undefined,
	current_points: 0,
	points: 0,
	current_x: -1000, 
};


// check if we're in a tutorial level
var _tutorial_flag = struct_get(_scene, "tutorial_flag");
var _tutorial_sequence = get_tutorial_sequence(_tutorial_flag);
if (_tutorial_sequence) {
	is_tutorial_scene = true;
}

// win/lose conditions
win = function() {
    change_state(GAME_STATE.VICTORY);
    publish(LEVEL_ENDED, "win");
    publish(DESTROYED_ALL_ENEMIES);
    audio_stop_sound(snd_timer_alarm);
}

lose = function() {
    change_state(GAME_STATE.GAME_OVER);
    publish(LEVEL_ENDED, "lose");
    audio_stop_sound(snd_timer_alarm);
}

update_key_count = function() {
    
    // only update the key count when we're not in a tutorial level
    // this prevents us from winning a level before meeting all tutorial requirements
    if (!is_tutorial_scene) {
    	collected_keys += 1;
    }

	// increment our score (TODO: put the points value in some kind of config) 
    // score += (100 + key_bonus);

    // advance to the next phase
    if (collected_keys >= goal_key_count && phase <= max_phase) {
        phase += 1;
        timer += 5;
        timer = clamp(timer, 0, max_timer);
        score += 50;
        win();
    }
    
}

enemy_defeated = function() {

    // update score based on current multiplier value
    show_debug_message("multiplier: " + string(multiplier));
    score += (10 + enemy_bonus) * multiplier;
    multiplier += 1;
    
    // clamp and start timer to reset multiplier 
    multiplier = clamp(multiplier, 1, max_multiplier);
    alarm_set(0, multiplier_timer);
    
    // track remaining number of enemies for win conditions, track # of enemies defeated for bonus
    var _enemy_count = 0;
    var _enemy_types = enemy_types;
    FOREACH _enemy_types ELEMENT
    	_enemy_count += instance_number(_elem);
    END
    enemies_defeated += 1;
    
    // if all enemies are defeated and that fulfills the win condition, end the level
    if (_enemy_count <= 0 && win_condition == "enemies") {
        win();
    }
    
}

lose_life = function() {
    
    no_lives_lost.achieved = false;
    
    if (is_tutorial_scene) {
    	return;
    }
    
    lives -= 1;
    
    if (lives <= 0) {
    	lives = 0;
        lose();
    }
    
}

gain_life = function() {
	
	lives += 1;
    
    if (lives >= 4) {
        lives = 4;
    }
    
}

// event subscriptions
subscribe(id, COLLECTED_KEY, update_key_count);
// subscribe(id, ENEMY_DEFEATED, enemy_defeated);
subscribe(id, LOST_LIFE, lose_life);
subscribe(id, GAINED_EXTRA_LIFE, gain_life);
subscribe(id, GAINED_EXTRA_TIME, function() {
	timer += 10;
});
subscribe(id, GAINED_EXTRA_POINTS, function() {
	score += 200;
});
subscribe(id, ACTIVATED_ENEMY_SCORE_BONUS, function() {
	enemy_bonus = 100;
});
subscribe(id, ACTIVATED_KEY_SCORE_BONUS, function() {
	key_bonus = 100;
});
subscribe(id, DEACTIVATED_POWERUP, function() {
	reset_powerups();
	powerup_active = false;
});
subscribe(id, ACTIVATED_POWERUP, function() {
	reset_powerups();
	powerup_timer = max_powerup_timer;
	powerup_active = true;
});
// subscribe(id, WON_LEVEL, win);
// subscribe(id, LOST_LEVEL, lose);
subscribe(id, CHARACTER_QUEUE_UPDATED, function(_characters = []) {
	
	var _character_id_array = [];
	FOREACH _characters ELEMENT
		var _character = real(_elem);
		array_push(_character_id_array, _character);
	END
	
	set_character_queue(_character_id_array);

});

// state machine behaviors
// -- COUNTDOWN
countdown_entrance_behavior = function() {
	stop_current_stinger();
	
	publish(ACTORS_DEACTIVATED, 0);
	publish(DISABLED_ENEMY_SPAWNING, 0);
	
	if (layer_exists("UI_Sequences")) {
		countdown_sequence = layer_sequence_create("UI_Sequences", 960, 448, seq_level_start_countdown);
	}
	
	stop_all_tracks();
};

countdown_active_behavior = function() {
	if (countdown_sequence != undefined && layer_sequence_is_finished(countdown_sequence)) {
		change_state(GAME_STATE.IN_LEVEL);
	}
}

countdown_exit_behavior = function() {
	publish(ACTORS_ACTIVATED, 0);
	publish(ENABLED_ENEMY_SPAWNING, 0);
	
	if (is_tutorial_scene) {
		publish(TUTORIAL_STARTED, 0);
	}
	
	layer_sequence_destroy(countdown_sequence);
}

// -- IN_LEVEL
in_level_behavior = function() {
    // use delta time for accurate timer counts
    var _delta_time = delta_time / 1000000;
    var _timer_tick_rate = 1* _delta_time;
    
    // ALERT SOUNDS
    if (timer <= 30 && !first_alert) {
        play_sound(snd_timer_warning, false);
        publish(WARNING_SOUNDED, 0);
        first_alert = true;
    }
 
    if (timer <= 10 && !second_alert) {
        play_sound(snd_timer_alarm, false);
        publish(ALARM_SOUNDED, 0);
        second_alert = true;
    }
    
    // slow down timer during the last 10 seconds
    if (timer <= 10) {
        _timer_tick_rate = 0.5 * _delta_time;    
    }
    
    // advance timer
    if (!is_tutorial_scene) {
    	timer -= _timer_tick_rate;
    }
    
    // end level when time runs out
    if (timer <= 0) {
    	timer = 0;
        lose();
    }
    
    // countdown until powerup deactivates
    if (powerup_active) {
	    if (powerup_timer > 0) {
	    	powerup_timer--;
	    }
	    
	    if (powerup_timer <= 0) {
	    	publish(DEACTIVATED_POWERUP);
	    }
    }
}

// -- VICTORY
victory_entrance_behavior = function() {
	
    show_debug_message("ENTER VICTORY STATE!");
    
    // calculate score bonuses on victory
    var _no_lives_lost_bonus = no_lives_lost.achieved ? 1000 : 0;
    var _enemies_bonus = enemies_defeated * 5;
    var _seconds_spent_in_level = clamp(max_timer - timer, 1, max_timer);
    var _time_bonus = is_tutorial_scene ? 1000 : floor((max_timer / _seconds_spent_in_level)) * 100;
    var _bonus_tally = _no_lives_lost_bonus + _enemies_bonus + _time_bonus;
    
    
    // update score structs
	no_lives_lost.points = _no_lives_lost_bonus;
	monster_bonus.points = _enemies_bonus;
	monster_bonus.tally = enemies_defeated;
	time_bonus.points = _time_bonus;
	time_bonus.tally = string(_seconds_spent_in_level) + " s";
	base_score.points = score;
	
	// update global score with bonuses
	score += _bonus_tally;
	total.points = score;
	
    // output final scores
    show_debug_message("No Lives Lost Bonus: " + string(_no_lives_lost_bonus));
    show_debug_message("Enemies Defeated Bonus: " + string(_enemies_bonus));
    show_debug_message("Time Bonus: " + string(_time_bonus));
    show_debug_message("Final Score: " + string(score));
	
	// start victory music
	play_stinger(snd_stinger_victory);
	
}

victory_behavior = function() {
    
}

victory_exit_behavior = function() {
    show_debug_message("EXIT VICTORY STATE!");
}

// -- GAME OVER
game_over_entrance_behavior = function() {
	show_debug_message("ENTER GAME OVER STATE!");
	show_debug_message("Level Score: " + string(score));
	show_debug_message("Final Score: " + string(score));
	
	base_score.points = score;
	total.points = score;
	
	play_stinger(snd_stinger_game_over);
	
	if (is_tutorial_scene) {
		publish(TUTORIAL_ENDED);
	}
}

game_over_behavior = function() {

}

game_over_exit_behavior = function() {
    show_debug_message("EXIT GAME OVER STATE!");
}

change_gm_state = function(_next_state = 0) {
	change_state(_next_state);
}

reset_powerups = function() {
	key_bonus = 0;
	enemy_bonus = 0;
}

// state machine init
states_array = [];
states_array[GAME_STATE.COUNTDOWN] = {
	entrance_behavior: countdown_entrance_behavior,
	active_behavior: countdown_active_behavior,
    exit_behavior: countdown_exit_behavior,
};
states_array[GAME_STATE.IN_LEVEL] = {
    entrance_behavior: function() {

        // reset multiplier
        multiplier = 1;
        
        // init level music
        music_tracks = struct_get(get_current_scene(), "music_layers");
        if (music_tracks != undefined && is_array(music_tracks)) {
        	play_layered_track(music_tracks, true);
        }
        
        publish(PLAYER_CHARACTER_SWITCHED, global.character_queue[global.character_index]);
        
    },
    active_behavior: in_level_behavior,
    exit_behavior: function() {},
};
states_array[GAME_STATE.GAME_OVER] = {
    entrance_behavior: game_over_entrance_behavior,
    active_behavior: game_over_behavior,
    exit_behavior: game_over_exit_behavior,
};
states_array[GAME_STATE.VICTORY] = {
    entrance_behavior: victory_entrance_behavior,
    active_behavior: victory_behavior,
    exit_behavior: victory_exit_behavior,
};

state = GAME_STATE.COUNTDOWN;
states_array[state].entrance_behavior();