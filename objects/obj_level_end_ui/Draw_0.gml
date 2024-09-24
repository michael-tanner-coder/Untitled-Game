draw_set_valign(fa_top);
if (data_source == undefined || data_source == noone) {
    return;
}

var _score_system = data_source;

// --- VICTORY UI ---
if (victory) {
    render_skip_inputs();
    render_level_end_scores("VICTORY!", score_structs, 30);
}

// --- GAME OVER UI ---
if (game_over) {
    render_skip_inputs();
    render_level_end_scores("GAME OVER!", [_score_system.base_score, _score_system.final_score], 240);
}