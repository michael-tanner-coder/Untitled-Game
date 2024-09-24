var _scene = global.scene_queue[global.scene_index];

var _scene_key = struct_get(_scene, "key");

if (room == rm_game_over) {
    _scene_key = "GAME OVER";
}

if (global.debug) {
    draw_outlined_text(x, 10, _scene_key, BLACK, fnt_header, 4, WHITE);
}

show_debug_overlay(global.debug);
