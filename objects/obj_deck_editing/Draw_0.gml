draw_shadow_text(452, 32, "CARDS: " + string(array_length(global.active_deck.cards)) + "/" + string(global.deck_limit));

if (fsm.event_exists("draw")) {
    fsm.draw();
}