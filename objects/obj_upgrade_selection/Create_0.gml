// Configuration Properties
// upgrade parameters
draw_score = 1000; // make this configurable
hand = [];
hand_size_limit = 3;

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

// State Machine
fsm = new SnowState("progress_to_next_draw");
        
fsm.add("progress_to_next_draw", {
    enter: function() {
        publish(ACTORS_ACTIVATED);
        physics_pause_enable(false);
        
        FOREACH card_obj_instances ELEMENT
        	instance_destroy(_elem);
        END

		card_obj_instances = [];
        upgrade_progress_points = 0;
    },
    step: function() {
        if (keyboard_check_pressed(vk_space)) {
            fsm.change("view_hand");
        }
    },
   	draw: function() {
   		if (upgrade_progress_points >= draw_score) {
   			banner(50, room_height/6, "PRESS SPACEBAR TO DRAW A CARD", BLACK, 0.6);
   		}
   		var _bar_bg_color = upgrade_progress_points >= draw_score ? WHITE : PURPLE;
		fillbar(progress_bar_x, progress_bar_y, 200, 25, min((upgrade_progress_points/draw_score), 1), RED, _bar_bg_color);
		draw_set_halign(fa_center);
	}
});

fsm.add("view_hand", {
    enter: function() {
    	if (upgrade_progress_points >= draw_score) {
    		// Increase target points for next upgrade; reset progress
        	draw_score *= 2;
        	upgrade_progress_points = 0;
        	draw_new_card();
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
    	fillbar(progress_bar_x, progress_bar_y, 200, 25,1, RED, WHITE);
		banner(upgrade_banner_height, upgrade_banner_y, "PLAY A CARD", BLACK, 0.6);
		draw_shadow_text(room_width/2, upgrade_banner_y + (upgrade_banner_height * 0.75), "(press SPACE to pass)")
	}
});

fsm.add("draw_card", {
	enter: function() {
		// Increase target points for next upgrade; reset progress
        draw_score *= 2;
        upgrade_progress_points = 0;
	},
	step: {},
	draw: {},
});

fsm.add("inactive", {
	step: function() {},
	draw: function() {},
})

// Methods
generate_card_hand = function() {
	var _available_cards = get_save_data_property("upgrades", global.default_unlocked_upgrades);
	
	// FIXME: this created a bug where only two card will appear in the list instead of three
	// if (global.most_recent_unlock != "") {
	// 	var _recent_unlocked_upgrade = get_upgrade_type(global.most_recent_unlock);
	// 	array_push(hand, _recent_unlocked_upgrade);
	// 	global.most_recent_unlock = "";
	// }
	
	for (var _i = 0; _i < hand_size_limit; _i++) {
		var _card_was_already_chosen = false;
		
		do {
			var _upgrade_key = _available_cards[irandom_range(0, array_length(_available_cards) - 1)];
			var _upgrade = get_upgrade_type(_upgrade_key);
			
        	_card_was_already_chosen = false;
        	FOREACH hand ELEMENT
        		if (_elem.key == _upgrade.key) {
        			_card_was_already_chosen = true;
        		}
        	END
			
			if (!_card_was_already_chosen) {
        		array_push(hand, _upgrade);
			}
		} until (_card_was_already_chosen == false)
			
	}
}

draw_new_card = function() {
	var _available_cards = get_save_data_property("upgrades", global.default_unlocked_upgrades);
	
	if (array_length(hand) < hand_size_limit) {
		var _upgrade_key = _available_cards[irandom_range(0, array_length(_available_cards) - 1)];
		var _upgrade = get_upgrade_type(_upgrade_key);
    	array_push(hand, _upgrade);
	}
}

discard_card = function(_card = {}) {
	var _card_to_remove_index = undefined;
	
	FOREACH hand ELEMENT
		if (_elem.key == _card.key) {
			_card_to_remove_index = _elem;
			break;
		}
	END
	
	if (_card_to_remove_index != undefined) {
		array_delete(hand, _card_to_remove_index, 1);
	}
}

// -- Randomly select cards for your starting hand 
generate_card_hand();

// Event Subscriptions
subscribe(id, UPGRADE_SELECTED, function(_card) {
	fsm.change("progress_to_next_draw");
	discard_card(_card);
});
subscribe(id, ENEMY_DEFEATED, function(_points = 0) {
	upgrade_progress_points += _points;
});
subscribe(id, LEVEL_RESET, function() {
	upgrade_progress_points = 0;
});
subscribe(id, LOST_LEVEL, function() {
	fsm.change("inactive");
})
