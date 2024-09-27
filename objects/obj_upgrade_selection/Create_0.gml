// Configuration Properties
upgrade_score = 2000; // make this configurable
available_upgrades = [];
upgrade_count = 3;
cards = [];
card_section_y = room_height/4 + 200;

// State Machine
fsm = new SnowState("progress_to_next_upgrade");

fsm.add("progress_to_next_upgrade", {
    enter: function() {
        publish(ACTORS_ACTIVATED);
        physics_pause_enable(false);
        
        FOREACH cards ELEMENT
        	instance_destroy(_elem);
        	array_delete(cards, _i, 0);
        END
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
    	// Increase target points for next upgrade
        upgrade_score *= 2;
        var _card_margin = 30;
        
        // Pause all characters in the scene
        publish(ACTORS_DEACTIVATED);
        physics_pause_enable(true);

		// Spawn upgrade cards
        var _start_x = room_width/2;
        var _section_width = 0;
        for (var _i = 0; _i < upgrade_count; _i++) {
        	var _card = instance_create_layer(x, y, "UI_Instances", obj_card);
        	_card.x = _start_x + ((_card.width + _card_margin) * _i);
        	_card.y = card_section_y;
        	_section_width += _card.width + _card_margin;
        	array_push(cards, _card);
        }
        
        // Reposition cards to center the section
        var _full_card_section_width = _section_width;
        FOREACH cards ELEMENT
        	var _card = _elem;
        	_card.x -= _full_card_section_width/2;
        END
    },
    step: function() {
        if (input_check_pressed("select")) {
            fsm.change("progress_to_next_upgrade");
        }
    },
    draw: function() {
		fillbar(room_width/2 - 100, room_height - 60, 200, 50, 1, RED, PURPLE);
		banner(200, room_height/4, "SELECT AN UPGRADE", BLACK, 0.6);
	}
});

// Event Subscriptions
subscribe(id, UPGRADE_SELECTED, function() {fsm.change("progress_to_next_upgrade")});