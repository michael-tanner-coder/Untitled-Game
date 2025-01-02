var _grid_width = (column_limit * sprite_get_width(object_get_sprite(record_object))) + ((column_limit-1) * record_margin_x);
var _grid_height = (row_limit * sprite_get_height(object_get_sprite(record_object))) + ((column_limit-1) * record_margin_y);
banner(_grid_height, starting_y, "", BLACK, 0.6);
draw_shadow_text(452, 32, "CARDS: " + string(array_length(global.active_deck.cards)) + "/" + string(global.deck_limit));
if (fsm.event_exists("draw")) {
    fsm.draw();
}