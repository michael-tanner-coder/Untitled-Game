// Files
global.save_file = "save_data.json";
global.input_settings = "input_save.json";

// Global game state
global.starting_life_count = 3;
global.paused = false;
global.intro = false;
global.debug = false;
global.dev_mode = true;
lives = global.starting_life_count;
global.settings = loadFromJson(global.save_file);
global.tension = 0;
global.first_wave_complete = false;
global.muted = false;

// Text
#macro TITLE "UNTITLED GAME"

// Game dimensions
#macro UNIT_SIZE 64
#macro SIZE_FACTOR 4

#macro TARGET_RESOLUTION_W 1920
#macro TARGET_RESOLUTION_H 1080

#macro VIEW view_camera[0]

// Game Rules
#macro STANDARD_SPAWN_RATE 450
#macro STANDARD_TIME_LIMIT 200

// Code snippets 

/*
Example usage:
    var _my_list = [1,2,3];
    FOREACH _my_list ELEMENT
        show_debug_message(string(_elem));
    END
*/
#macro FOREACH var _get_list = 
#macro ELEMENT ; for(var _i = 0; _i < array_length(_get_list); _i++) { \
    var _elem = _get_list[_i];
#macro END }

// Sound Macros
#macro DUPLICATE_SOUND_TOLERANCE 0.1

// Events
#macro PLAYER_WARPED "player_warped"
#macro PLAYER_DAMAGED "hit_by_enemy"
#macro LOST_LIFE "lost_life"
#macro PLAYER_STOMPED "stomp"
#macro SCREENSHAKED "screenshake"
#macro ENEMY_FLIPPED "enemy_flipped"
#macro ENEMY_DEFEATED "enemy_defeated"
#macro BUMPED_BLOCK "block_bumped"
#macro FELL_FAST "fell_fast"
#macro DESTROYED_BLOCK "destroyed_block"
#macro COLLECTED_KEY "collect_key"
#macro ENABLED_KEY_SPAWNING "enabled_key_spawning"
#macro DISABLED_KEY_SPAWNING "disabled_key_spawning"
#macro ENABLED_ENEMY_SPAWNING "enabled_enemy_spawning"
#macro DISABLED_ENEMY_SPAWNING "disabled_enemy_spawning"
#macro SPAWN_ONLY_KEY_ENEMIES "spawn_only_key_enemies"
#macro SPAWN_NO_KEY_ENEMIES "spawn_no_key_enemies"
#macro RESET_KEY_ENEMY_SPAWN_CHANCE "reset_key_enemy_spawn_chance"
#macro DESTROYED_ALL_ENEMIES "destory_all_enemies"
#macro FLIPPED_ALL_ENEMIES "flip_all_enemies"
#macro LEVEL_ENDED "end_level"
#macro WON_LEVEL "win_level"
#macro LOST_LEVEL "lose_level"
#macro ACTORS_DEACTIVATED "deactivate_all_actors"
#macro ACTORS_ACTIVATED "activate_all_actors"
#macro WARNING_SOUNDED "warning"
#macro ALARM_SOUNDED "alarm"
#macro CHARACTER_QUEUE_UPDATED "character_queue_updated"
#macro PLAYER_CHARACTER_SWITCHED "player_character_switched"
#macro GRID_REBUILT "rebuild_grid"
#macro TUTORIAL_STARTED "start_tutorial"
#macro TUTORIAL_ENDED "end_tutorial"
#macro GAINED_EXTRA_LIFE "extra_life"
#macro GAINED_EXTRA_TIME "extra_time"
#macro GAINED_EXTRA_POINTS "extra_points"
#macro ACTIVATED_POWERUP "activated_powerup"
#macro DEACTIVATED_POWERUP "deactivated_powerup"
#macro ACTIVATED_KEY_SCORE_BONUS "key_score_bonus"
#macro ACTIVATED_ENEMY_SCORE_BONUS "enemy_score_bonus"
#macro ACTIVATED_SWITCH_ON_KEY_COLLECT "switch_on_key_collect"
#macro ACTIVATED_BONUS_IFRAMES "bonus_iframes"
#macro SPAWNED_SLOWDOWN_FIELD "slowdown_field"
#macro FREEZE_ALL_ENEMIES "freeze_enemies"
#macro ACTIVATE_EXPLODING_ENEMIES "exploding_enemies"
#macro PURCHASED_ITEM "purchased_item"
#macro FINISHED_SCENE "finished_scene"
#macro UPDATE_TEXT "update_text"
#macro FULLSCREEN_TOGGLED "fullscreen_toggled"
#macro UPGRADE_SELECTED "upgrade_selected"

// Flags
#macro STARTED_GAME "started_game"
#macro PLAYED_NORMAL_CHARACTER "played_normal_character"
#macro PLAYED_TALL_CHARACTER "played_tall_character"
#macro PLAYED_SMALL_CHARACTER "played_small_character"
#macro PLAYED_BIG_CHARACTER "played_big_character"
#macro PLAYED_BOUNCE_CHARACTER "played_bounce_character"
#macro PLAYED_SPIKEY_CHARACTER "played_spikey_character"
#macro PLAYED_FLOAT_CHARACTER "played_float_character"
#macro PLAYED_TWIN_CHARACTER "played_twin_character"

global.tutorial_flag_list = [
	PLAYED_NORMAL_CHARACTER, 
	PLAYED_TALL_CHARACTER, 
	PLAYED_SMALL_CHARACTER, 
	PLAYED_BIG_CHARACTER, 
	PLAYED_BOUNCE_CHARACTER,
	PLAYED_SPIKEY_CHARACTER,
	PLAYED_FLOAT_CHARACTER,
	PLAYED_TWIN_CHARACTER
];

// Enums
enum CHARACTER {
    NORMAL = 0,
    SMALL = 1,
    TALL = 2,
    BIG = 3,
    SPIKEY = 4,
    BOUNCE = 5,
    TWIN = 6,
    FLOAT = 7,
    TWIN_BLUE = 8,
}

enum GAME_STATE {
	IN_LEVEL,
	VICTORY,
	GAME_OVER,
	LEVEL_TRANSITION,
	COUNTDOWN
}

enum PLAYER_STATE {
    IDLE = 0, 
    RUNNING = 1,
    HURT = 2,
}

enum ACTOR_STATE {
    IDLE = 0, 
    MOVING = 1,
    HURT = 2,
	PAUSED = 3,
	FLIPPED = 4,
	LANDED = 5,
	SHOOTING = 6,
	INACTIVE = 7,
}

enum ORIENTATIONS {
	VERTICAL = 0,
	HORIZONTAL = 1
};

enum OPERATIONS {
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE,
	SET,
}

enum ABILITIES {
	DASH,
	BOMB,
	WAVE,
	TELEPORT,
	BOUNCER,
}

// Colors
#macro PINK $BA7BD7
#macro BLUE $FF9B63
#macro DARK_BLUE $2C1E19
#macro YELLOW $75CDFF
#macro BLACK $342022

#macro WHITE $F8F8E8
#macro PURPLE $884848
#macro GREEN $68BD48
#macro RED $78878E6
#macro ORANGE $88B8F8

// Text
#macro STANDARD_OUTLINE_DISTANCE 4



// Data Structures
global.inactive_instances = [];
global.collidable_list = [];
global.enemy_list = [];

function add_inactive_instance(_inst) {
	
	if (_inst == undefined) {
		show_debug_message("Error: provided instance either does not exist");
		return;
	}
	
	array_push(global.inactive_instances, _inst);
	
}

function remove_inactive_instance(_inst) {
	
	inactive_instance = _inst;
	
	if (inactive_instance == undefined) {
		show_debug_message("Error: provided instance either does not exist or does not have an ID");
		return;
	} 
	
	var _find_matching_instance_id = function(_element) {
		return _element == inactive_instance;		
	}
	
	var _index = array_find_index(global.inactive_instances, _find_matching_instance_id);
	array_delete(global.inactive_instances, _index, 0);
	
}






