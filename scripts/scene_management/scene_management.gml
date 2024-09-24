// Global scene properties
global.current_scene = {};
global.scene_index = 0;

// Scene transition functions
function scene_transition(_scene = {}) {
    
    var _map = struct_get(_scene, "map");
    
    global.current_scene = _scene;
    
    room_goto(_map);

}

function go_to_scene_by_key(_key = "") {
    
    if (!is_string(_key)) {
        show_debug_message("Error: Provided key is not a string");
        return;
    }
    
    var _found_scene = undefined;
    var _found_scene_index = 0;
    
    FOREACH global.scene_queue ELEMENT
        if (_elem.key == _key) {
            _found_scene = _elem;
            _found_scene_index = _i;
        } 
    END
    
    if (_found_scene != undefined) {
        scene_transition(_found_scene);
        global.scene_index = _found_scene_index;
    }
    
}

function go_to_next_scene() {
    
    var _next_scene = get_next_scene();
    
    if (_next_scene != undefined) {
    	var _tutorial_flag = struct_get(_next_scene, "tutorial_flag");
    	if (is_string(_tutorial_flag) && get_flag(_tutorial_flag)) {
    		global.scene_index += 1;
    		go_to_next_scene();
    		return;
    	}
    }
    
    if (_next_scene != undefined) {
        scene_transition(_next_scene);
        global.scene_index += 1;
    }
    
    if (global.scene_index > array_length(global.scene_queue) - 1) {
        global.scene_index = array_length(global.scene_queue) - 1;
    }

}

function go_to_previous_scene() {
    
    var _previous_scene = get_previous_scene();
    
    if (_previous_scene != undefined) {
        scene_transition(_previous_scene);
        global.scene_index -= 1;
    }
    
    if (global.scene_index < 0) {
        global.scene_index = 0;
    }

}

function get_next_scene() {
    
    if (global.scene_index + 1 > array_length(global.scene_queue) - 1) {
        return undefined;
    }
    
    return global.scene_queue[global.scene_index + 1];
    
}

function get_previous_scene() {
    
    if (global.scene_index - 1 < 0) {
        return undefined;
    }
    
    return global.scene_queue[global.scene_index - 1];
    
}

function get_current_scene() {
    
    if (global.scene_index <= array_length(global.scene_queue) - 1) {
        return global.scene_queue[global.scene_index];
    }
    else {
        return global.scene_queue[array_length(global.scene_queue) - 1];
    }
    
}


// External scene functions
function start_game() {
    
    var _started_game = get_flag("started_game");
    
    if (!_started_game) {
        set_flag("started_game", true);
        
        go_to_scene_by_key("level");
        
        return;
    }
    
    go_to_next_scene();
    
}

function new_game() {
    
    set_flag("started_game", false);
    
    FOREACH global.tutorial_flag_list ELEMENT
    	var _flag = _elem;
    	set_flag(_flag, false);
    END
    
    start_game();
    
}

function win_level() {
    
    go_to_next_scene();

}

function lose_game() {
    
    global.scene_index = 0;
    room_goto(rm_game_over);
    
}

function reset_game_state() {
	score = 0;
	lives = global.starting_life_count;
    global.powerups_spawn_list = [];
}

function restart_game() {
    
	reset_game_state();
    go_to_scene_by_key("1-1");
    
}

function loop_game() {
    
    // keep player's score
    go_to_scene_by_key("1-1");
    
}

function quit_to_menu() {
    
    menuModeTitle(); 
	menuSetPreset(e_menu_presets.title_screen);
	go_to_scene_by_key("main-menu")		
    
}

