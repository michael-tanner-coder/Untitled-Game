// TODO: 
// Implement arena unlock notification
// Tie boss defeat to arena unlock
// Take player to victory screen when finishing last arena

function level_struct(_key = "", _name = "", _preview_sprite = undefined, _best_score = 0, _card_set_key = "", _unlock_progress = 0, _max_unlock_progress = 0) {
    return {
        key: _key,
        preview_sprite: undefined,
        name: _name,
        best_score: _best_score,
        card_set: _card_set_key,
        unlock_progress: _unlock_progress,
        max_unlock_progress: _max_unlock_progress,
    };
}

global.levels = [];
global.chosen_level = "level_1";

function init_levels_collection() {
    global.levels = [
        level_struct("level_1", "Jack Arena", undefined, 0, "basic_set", 0, 40000),
        level_struct("level_2", "Queen Arena", undefined, 0, "advanced_set", 0, 80000),
        level_struct("level_3", "King Arena", undefined, 0, "pro_set", 0, 160000),
        level_struct("level_4", "Joker Arena", undefined, 0, "final_set", 0, 320000),
    ];
    
    return global.levels;
}

function unlock_level(_level = "") {
    
    if (!is_string(_level)) {
        show_debug_message("Error: Provided level key is not a string");
        return;
    }
    
    var _save_data = loadFromJson(global.save_file);
    
    var _levels = _save_data.unlocked_levels;
    
    if (array_contains(_levels, _level)) {
        show_debug_message("Error: Provided level is already unlocked");
        return;
    }
    
    array_push(_levels, _level);
    
    saveToJson(_save_data, global.save_file);
    
}

function reset_unlocked_levels() {
    
    var _save_data = loadFromJson(global.save_file);
    
    _save_data.unlocked_levels = ["level_1"];
    
    saveToJson(_save_data, global.save_file);
    
}

init_levels_collection();