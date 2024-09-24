global.high_score_limit = 5;

function sort_scores(_elem_a = 0, _elem_b = 0) {
    return _elem_a - _elem_b;
}

function update_high_scores(_score = 0) {
    
    var _new_highscore = false;
    
    if (!is_numeric(_score)) {
        show_debug_message("Error: Provided score is not a number");
        return;
    }
    
    var _save_data = loadFromJson(global.save_file);
    
    var _highscores = _save_data.highscores;
    
    if (array_length(_highscores) < global.high_score_limit) {
        _new_highscore = true;
    }
    
    FOREACH _highscores ELEMENT
        if (_score > _elem) {
            _new_highscore = true;
        }
        
        if (_score == _elem) {
            _new_highscore = false;
        }
    END
    
    if (_new_highscore) {
        array_push(_highscores, _score);
        array_sort(_highscores, sort_scores);
    }
    
    while (array_length(_highscores) > global.high_score_limit) {
        array_delete(_highscores, 0, 1);
    }
    
    _save_data.highscores = _highscores;
    
    saveToJson(_save_data, global.save_file);

}

function clear_high_scores() {
    
    var _save_data = loadFromJson(global.save_file);
    
    _save_data.highscores = [];
    
    saveToJson(_save_data, global.save_file);

}