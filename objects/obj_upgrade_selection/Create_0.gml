// Configuration Properties
// upgrade parameters
draw_score = 1000; // make this configurable
hand = [];
hand_size_limit = 3;
deck = [];
hand_full = false;
var _len = array_length(global.deck);
array_copy(deck, 0, global.deck, 0, _len);

// card section
card_obj_instances = [];
starting_card_section_y = room_height + 10;
card_section_y = room_height/4 + 200;
upgrade_banner_y = -1000;
target_upgrade_banner_y = room_height/4;
upgrade_banner_height = 200;

// progress bar
upgrade_progress_points = 0;
progress_bar_y = 30;
progress_bar_x = room_width/2 - 100;

// 
actor_activation_timer = -1;

// State Machine
fsm = new SnowState("progress_to_next_draw");
        
fsm.add("progress_to_next_draw", {
    enter: function() {
        FOREACH card_obj_instances ELEMENT
        	instance_destroy(_elem);
        END

		card_obj_instances = [];
        actor_activation_timer = 5;
    },
    step: function() {
        if (input_check_pressed("select") && (array_length(deck) > 0 || array_length(hand) > 0)) {
            fsm.change("view_hand");
        }
        
        // hold off on activating actors until we pass a given number of frames
        actor_activation_timer--;
        if (actor_activation_timer == 0) {
    		publish(ACTORS_ACTIVATED);
        	physics_pause_enable(false);
        	actor_activation_timer = -1;
        }
    },
   	draw: function() {
   		if (upgrade_progress_points >= draw_score && array_length(deck) > 0) {
   			banner(50, room_height/6, "PRESS R TO DRAW A CARD", BLACK, 0.6);
   		}
   		var _bar_bg_color = upgrade_progress_points >= draw_score ? WHITE : PURPLE;
		fillbar(progress_bar_x, progress_bar_y, 200, 25, min((upgrade_progress_points/draw_score), 1), RED, _bar_bg_color);
		draw_set_halign(fa_center);
		draw_shadow_text(VIEW_WIDTH/2 + 150, 14, "DECK: " + string(array_length(deck)));
	}
});

fsm.add("view_hand", {
    enter: function() {
    	if (upgrade_progress_points >= draw_score && array_length(deck) > 0) {
    		fsm.change("draw_card");
    		return;
    	}
    	
        var _card_margin = 30;
        
        // Pause all characters in the scene
        publish(ACTORS_DEACTIVATED);
        physics_pause_enable(true);

		// Spawn card_obj_instances
        var _start_x = room_width/2;
        var _section_width = 0;
        for (var _i = 0; _i < array_length(hand); _i++) {
        	
        	// Base position for card
        	var _card = instance_create_layer(x, y, "UI_Instances", obj_card);
        	_card.x = _start_x + ((sprite_get_width(_card.sprite_index) + _card_margin) * _i);
        	_card.y = starting_card_section_y;
        	_card.starting_y = _card.y;
        	_card.target_y = card_section_y;
        	_card.resting_y = card_section_y;
        	_card.time_until_active = 10 * _i;
        	_section_width += sprite_get_width(_card.sprite_index) + _card_margin;
        	
        	// Upgrade data for card
        	var _upgrade = hand[_i];
        	_card.upgrade = _upgrade;
        	_card.header = _upgrade.name;
        	_card.description = _upgrade.description;
        	_card.price = _upgrade.price;
        	_card.sprite = _upgrade.sprite;
        	
        	// Cache all card_obj_instances for disposal later
        	array_push(card_obj_instances, _card);
        	
        }
        
        // Reposition card_obj_instances to center the section
        var _full_card_section_width = _section_width;
        FOREACH card_obj_instances ELEMENT
        	var _card = _elem;
        	_card.x -= _full_card_section_width/2;
        END
    },
    step: function() {
        upgrade_banner_y = lerp(upgrade_banner_y, target_upgrade_banner_y, 0.2);
        
        if (input_check_pressed("select")) {
        	fsm.change("progress_to_next_draw");
        }
    },
    draw: function() {
    	var _bar_bg_color = upgrade_progress_points >= draw_score ? WHITE : PURPLE;
		fillbar(progress_bar_x, progress_bar_y, 200, 25, min((upgrade_progress_points/draw_score), 1), RED, _bar_bg_color);
		banner(upgrade_banner_height, upgrade_banner_y, "SPEND MANA TO PLAY A CARD (left-click)", BLACK, 0.6);
		draw_shadow_text(room_width/2, upgrade_banner_y + (upgrade_banner_height * 0.65), "DISCARD A CARD TO GAIN MANA (right-click)", ORANGE);
		draw_shadow_text(room_width/2, upgrade_banner_y + (upgrade_banner_height * 0.90), "(press R to close)");
	}
});

fsm.add("draw_card", {
    enter: function() {
    	hand_full = array_length(hand) >= hand_size_limit;
    	
    	if (upgrade_progress_points >= draw_score && !hand_full) {
    		// Increase target points for next upgrade; reset progress
        	draw_score *= 2;
        	upgrade_progress_points = 0;
        	draw_new_card();
        	fsm.change("view_hand");
    	} else {
    		fsm.change("discard");
    	}
    },
    step: function() {
        upgrade_banner_y = lerp(upgrade_banner_y, target_upgrade_banner_y, 0.2);
        
        if (input_check_pressed("select")) {
        	fsm.change("progress_to_next_draw");
        }
    },
    draw: function() {
    	var _bar_bg_color = upgrade_progress_points >= draw_score ? WHITE : PURPLE;
		fillbar(progress_bar_x, progress_bar_y, 200, 25, min((upgrade_progress_points/draw_score), 1), RED, _bar_bg_color);
	}
}
);

fsm.add("discard", {
	enter: function() {
		var _card_margin = 30;
        
        // Pause all characters in the scene
        publish(ACTORS_DEACTIVATED);
        physics_pause_enable(true);

		// Spawn card_obj_instances
        var _start_x = room_width/2;
        var _section_width = 0;
        for (var _i = 0; _i < array_length(hand); _i++) {
        	
        	// Base position for card
        	var _card = instance_create_layer(x, y, "UI_Instances", obj_card);
        	_card.x = _start_x + ((sprite_get_width(_card.sprite_index) + _card_margin) * _i);
        	_card.y = starting_card_section_y;
        	_card.starting_y = _card.y;
        	_card.target_y = card_section_y;
        	_card.resting_y = card_section_y;
        	_card.time_until_active = 10 * _i;
        	_section_width += sprite_get_width(_card.sprite_index) + _card_margin;
        	
        	// Upgrade data for card
        	var _upgrade = hand[_i];
        	_card.upgrade = _upgrade;
        	_card.header = _upgrade.name;
        	_card.description = _upgrade.description;
        	_card.price = _upgrade.price;
        	_card.sprite = _upgrade.sprite;
        	
        	// Cache all card_obj_instances for disposal later
        	array_push(card_obj_instances, _card);
        	
        }
        
        // Reposition card_obj_instances to center the section
        var _full_card_section_width = _section_width;
        FOREACH card_obj_instances ELEMENT
        	var _card = _elem;
        	_card.x -= _full_card_section_width/2;
        END
	},
	step: function() {
		 upgrade_banner_y = lerp(upgrade_banner_y, target_upgrade_banner_y, 0.2);
        
        if (input_check_pressed("select")) {
        	fsm.change("progress_to_next_draw");
        }
	},
	draw: function() {
		fillbar(progress_bar_x, progress_bar_y, 200, 25,1, RED, WHITE);
		banner(upgrade_banner_height, upgrade_banner_y, "HAND IS FULL: DISCARD A CARD (right-click or press 'X')", BLACK, 0.6, RED);
		draw_shadow_text(room_width/2, upgrade_banner_y + (upgrade_banner_height * 0.75), "(press R to pass)")
	},
})

fsm.add("inactive", {
	step: function() {},
	draw: function() {},
})

// Methods
generate_card_hand = function() {
	if (array_length(deck) <= 0) {
		return;
	}
	
	// FIXME: this created a bug where only two card will appear in the list instead of three
	// if (global.most_recent_unlock != "") {
	// 	var _recent_unlocked_upgrade = get_upgrade_type(global.most_recent_unlock);
	// 	array_push(hand, _recent_unlocked_upgrade);
	// 	global.most_recent_unlock = "";
	// }
	var _cards_to_remove = [];
	for (var _i = 0; _i < hand_size_limit-1; _i++) {
		var _upgrade_struct = deck[irandom_range(0, array_length(deck) - 1)];
		var _upgrade = get_upgrade_type(_upgrade_struct.key);
		array_push(hand, _upgrade);
		array_push(_cards_to_remove, _upgrade_struct);
	}
	
	FOREACH _cards_to_remove ELEMENT
		remove_from_temp_deck(_elem);
	END
}

draw_new_card = function() {
	if (array_length(hand) < hand_size_limit && array_length(deck) > 0) {
		var _upgrade_struct = deck[irandom_range(0, array_length(deck) - 1)];
		var _upgrade = get_upgrade_type(_upgrade_struct.key);
    	array_push(hand, _upgrade);
    	remove_from_temp_deck(_upgrade_struct);
	}
}

discard_card = function(_card = {}) {
	var _card_to_remove_index = undefined;
	
	FOREACH hand ELEMENT
		if (_elem.key == _card.key) {
			_card_to_remove_index = _i;
			break;
		}
	END
	
	if (_card_to_remove_index != undefined) {
		array_delete(hand, _card_to_remove_index, 1);
	}
}

remove_from_temp_deck = function(_card = {}) {
	var _card_to_remove_index = undefined;
	
	FOREACH deck ELEMENT
		if (_elem.key == _card.key) {
			_card_to_remove_index = _i;
			break;
		}
	END
	
	if (_card_to_remove_index != undefined) {
		array_delete(deck, _card_to_remove_index, 1);
	}
}

// -- Randomly select cards for your starting hand 
generate_card_hand();

// Event Subscriptions
subscribe(id, UPGRADE_SELECTED, function(_card) {
	if (fsm.get_current_state() == "discard") {
		discard_card(_card);
	
		FOREACH card_obj_instances ELEMENT
	        	instance_destroy(_elem);
	    END
	
		card_obj_instances = [];
	
		fsm.change("view_hand");
	} else {
		fsm.change("progress_to_next_draw");
		discard_card(_card);
	}
});
subscribe(id, ENEMY_DEFEATED, function(_points = 0) {
	upgrade_progress_points += _points;
});
subscribe(id, LEVEL_RESET, function() {
	upgrade_progress_points = 0;
});
subscribe(id, LOST_LEVEL, function() {
	fsm.change("inactive");
});
subscribe(id, DISCARD_CARD, function(_card) {
	discard_card(_card);
	
	FOREACH card_obj_instances ELEMENT
        	instance_destroy(_elem);
    END

	card_obj_instances = [];
	
	fsm.change("view_hand");
});
