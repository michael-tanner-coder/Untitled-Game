// Global scene properties
global.current_scene = {};
global.scene_index = 0;

// Scene transition functions
function scene_transition(_scene = {}) {
    
    var _map = struct_get(_scene, "map");
    
    global.current_scene = _scene;
    
    room_goto(_map);

}

function get_scene_by_key(_key = "") {
	
	if (!is_string(_key)) {
        show_debug_message("Error: Provided key is not a string");
        return;
    }
    
    var _found_scene = undefined;
    var _found_scene_index = 0;
    
    FOREACH global.scenes ELEMENT
        if (_elem.key == _key) {
            _found_scene = _elem;
            _found_scene_index = _i;
        } 
    END
    
    
    return _found_scene;
    
} 

function go_to_scene_by_key(_key = "") {
    
    if (!is_string(_key)) {
        show_debug_message("Error: Provided key is not a string");
        return;
    }
    
    var _found_scene = undefined;
    var _found_scene_index = 0;
    
    FOREACH global.scenes ELEMENT
        if (_elem.key == _key) {
            _found_scene = _elem;
            _found_scene_index = _i;
        } 
    END
    
    if (_found_scene != undefined) {
        scene_transition(_found_scene);
        global.scene_index = _found_scene_index;
    }
    
    // push to stack of scene keys to track our routing throughout the game
    if (array_length(global.scene_stack) == 0 || global.scene_stack[array_length(global.scene_stack)-1] != _key) {
    	array_push(global.scene_stack, _key);
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
    
    if (global.scene_index > array_length(global.scenes) - 1) {
        global.scene_index = array_length(global.scenes) - 1;
    }

}

function go_to_previous_scene() {
    array_pop(global.scene_stack);
    
    if (array_length(global.scene_stack) > 0) {
    	var _previous_scene_key = global.scene_stack[array_length(global.scene_stack)-1];
    	go_to_scene_by_key(_previous_scene_key);
    }
}

function get_next_scene() {
    
    if (global.scene_index + 1 > array_length(global.scenes) - 1) {
        return undefined;
    }
    
    return global.scenes[global.scene_index + 1];
    
}

function get_current_scene() {
    
    if (global.scene_index <= array_length(global.scenes) - 1) {
        return global.scenes[global.scene_index];
    }
    else {
        return global.scenes[array_length(global.scenes) - 1];
    }
    
}


// External scene functions
function start_game() {
    
    var _started_game = get_flag("started_game");
    
    if (!_started_game) {
        set_flag("started_game", true);
        
        go_to_scene_by_key("level-selection");
        
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

function go_to_end_scene() {
	
	menuModeTitle(); 
	menuSetPreset(e_menu_presets.title_screen);
	go_to_scene_by_key("end-screen")		
	
}

