// Configuration Properties
upgrade_score = 2000; // make this configurable

// State Machine
fsm = new SnowState("progress_to_next_upgrade");

fsm.add("progress_to_next_upgrade", {
    enter: function() {
        publish(ACTORS_ACTIVATED);
        physics_pause_enable(false);
    },
    step: function() {
        if (score >= upgrade_score) {
            fsm.change("select_upgrade");
        }
    },
   	draw: function() {
		fillbar(room_width/2 - 100, room_height - 60, 200, 50, min((score/upgrade_score), 1), RED, PURPLE);
		draw_set_halign(fa_center);
		draw_shadow_text(room_width/2, room_height - 60, "NEXT UPGRADE " + string(score) + "/" + string(upgrade_score));
	}
});

fsm.add("select_upgrade", {
    enter: function() {
        upgrade_score *= 2;
        publish(ACTORS_DEACTIVATED);
        physics_pause_enable(true);
    },
    step: function() {
        if (input_check_pressed("select")) {
            fsm.change("progress_to_next_upgrade");
        }
    },
    draw: function() {
		fillbar(room_width/2 - 100, room_height - 60, 200, 50, 1, RED, PURPLE);
		draw_set_halign(fa_center);
		draw_shadow_text(room_width/2, room_height - 60, "SELECT AN UPGRADE");
	}
});