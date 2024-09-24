/// @description Insert description here
if (!global.dev_mode) {
    return;
}


if (keyboard_check_pressed(ord("K"))) {
    global.debug = !global.debug;
}

// if (is_debug_overlay_open()) {
//     return;
// }

if (keyboard_check_pressed(ord("U"))) {
    reset_unlocks();
}

if (keyboard_check_pressed(ord("E"))) {
    publish("win_level");
}

if (keyboard_check_pressed(ord("L"))) {
    publish("lose_level");
}

if (keyboard_check_pressed(ord("X"))) {
    publish(DESTROYED_ALL_ENEMIES);
}

if (keyboard_check_pressed(ord("F"))) {
    publish(FLIPPED_ALL_ENEMIES);
}

if (keyboard_check_pressed(ord("Z"))) {
    var _num = irandom(10000);
    screen_save("screen_" + string(_num) + ".png");
}

// Menu options
if (room == rm_main_menu) {
    // New Game
    if (keyboard_check_pressed(ord("N"))) {
        new_game();
    }
    // Continue game
    if (keyboard_check_pressed(ord("C"))) {
        start_game();
    }
}

// General Scene transitions
if (room != rm_main_menu && room != rm_game_over && room != rm_outro) {
        
	if (keyboard_check_pressed(ord("1"))) {
	    room_goto(rm_combat_test);
	}
	if (keyboard_check_pressed(ord("2"))) {
	    room_goto(rm_combat_test_2);
	}
	if (keyboard_check_pressed(ord("3"))) {
	    room_goto(rm_combat_test_3);
	}
	if (keyboard_check_pressed(ord("4"))) {
	    room_goto(rm_combat_test_4);
	}
    
}

// Options on game over
if (room == rm_game_over) {
    if (keyboard_check_pressed(ord("R"))) {
        restart_game();
    }
    
    if (keyboard_check_pressed(ord("Q"))) {
        quit_to_menu();
    }
}

if (room == rm_outro) {
    if (keyboard_check_pressed(ord("R"))) {
        loop_game();
    }
    
    if (keyboard_check_pressed(ord("Q"))) {
        quit_to_menu();
    }
}

// Scene selection
if (keyboard_check_pressed(ord("1"))) {
    go_to_scene_by_key("1-1");
}

if (keyboard_check_pressed(ord("2"))) {
    go_to_scene_by_key("2-1");
}

if (keyboard_check_pressed(ord("3"))) {
    go_to_scene_by_key("3-1");
}

if (keyboard_check_pressed(ord("4"))) {
    go_to_scene_by_key("4-1");
}
