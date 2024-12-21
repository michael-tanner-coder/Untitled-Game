// Configuration Properties
// upgrade parameters
draw_score = 1000; // make this configurable
hand = [];
discard_pile = [];
hand_size_limit = 3;
deck = [];
hand_full = false;
selected_cards = [];
selection_price = 0;
retrieve_count = 0;

var _len = array_length(global.deck);
array_copy(deck, 0, global.deck, 0, _len);

// card section
card_obj_instances = [];
starting_card_section_y = room_height + 10;
card_section_y = room_height/4 + 200;
upgrade_banner_y = -1000;
target_upgrade_banner_y = room_height/4;
upgrade_banner_height = 200;

// buttons
play_button = undefined;
discard_button = undefined;
retrieve_button = undefined;

// draw indictator
flash_time = 0;
got_lucky_draw = false;

// progress bar
upgrade_progress_points = 0;
progress_bar_y = 18;
progress_bar_x = 380;

// 
actor_activation_timer = -1;

// Methods
draw_card_meter = function() {
	// Draw Meter + Deck Icon
	draw_sprite(spr_deck_card_east_bay, 0, progress_bar_x + 4, progress_bar_y + 4);
	draw_sprite(spr_deck_card_purple, 0, progress_bar_x + 2, progress_bar_y + 2);
	draw_sprite(spr_deck_card_white, 0, progress_bar_x, progress_bar_y);
	
	// Draw Fill Bar
	var _fill_width = sprite_get_width(spr_deck_card_fill);
	var _fill_height = sprite_get_height(spr_deck_card_fill);
	var _fill_x = progress_bar_x;
	var _fill_y = progress_bar_y + _fill_height - (_fill_height * min((upgrade_progress_points/draw_score), 1));
	draw_sprite_part(spr_deck_card_fill, 0, 0, _fill_height - (_fill_height * min((upgrade_progress_points/draw_score), 1)), _fill_width, _fill_height, _fill_x, _fill_y);
	
	// Lucky Draw Fill Bar
	var _excess_points = max(upgrade_progress_points - draw_score, 0);
	var _excess_fill_x = progress_bar_x;
	var _excess_fill_y = progress_bar_y + _fill_height - (_fill_height * min((_excess_points/draw_score), 1));
	if (_excess_points > 0) {
		draw_sprite_part(spr_deck_card_fill_lucky, 0, 0, _fill_height - (_fill_height * min(_excess_points/draw_score, 1)), _fill_width, _fill_height, _excess_fill_x, _excess_fill_y);
	}
	
	// Card Count
	var _card_count_y = progress_bar_y-3;
	draw_set_halign(fa_center);
	draw_shadow_text(progress_bar_x + _fill_width * 2, _card_count_y + _fill_width/2, "x " + string(array_length(deck)));
}

// State Machine
fsm = new SnowState("progress_to_next_draw");
        
fsm.add("progress_to_next_draw", {
    enter: function() {
    	if (play_button != undefined) {
    		instance_destroy(play_button);
    	}
    	
    	if (discard_button != undefined) {
	    	instance_destroy(discard_button);
    	}	
        
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
        
        if (input_check_pressed("view_discard_pile")) {
            fsm.change("view_discard_pile");
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
   		
		draw_card_meter();
		
		// Card Draw Indicator
		// --only start rendering indicator when we have filled the draw progress meter
		var _excess_points = max(upgrade_progress_points - draw_score, 0);
   		var _show_draw_indicator = upgrade_progress_points >= draw_score;
   		var _show_lucky_draw_indicator = _excess_points >= draw_score;
   		var _draw_indicator = _show_lucky_draw_indicator ? spr_lucky_draw_indicator : spr_draw_indicator;
   		
		// -- toggle rendering of indicator at regular intervals
		flash_time++;
		if (flash_time >= 30) {
			_show_draw_indicator = false;
		}
		flash_time = loop_clamp(flash_time, 0, 60);
		
		// 
		if (_show_draw_indicator && array_length(deck) > 0) {
			draw_sprite(_draw_indicator, 0, progress_bar_x + sprite_get_width(spr_draw_indicator)/2, progress_bar_y - sprite_get_height(spr_draw_indicator)/2);
		}
	}
});

fsm.add("view_hand", {
    enter: function() {
    	selection_price = 0;
    	selected_cards = [];
    		
    	if (upgrade_progress_points >= draw_score && array_length(deck) > 0) {
    		fsm.change("draw_card");
    		return;
    	}
    	
        var _card_margin = 30;
        
        // Pause all characters in the scene
        publish(ACTORS_DEACTIVATED);
        physics_pause_enable(true);
        
        // Spawn buttons
        play_button = instance_create_layer(60, 90, "UI_Instances", obj_button);
        play_button.text = "PLAY";
        play_button.on_click_event = PLAYED_CARD;
        
        discard_button = instance_create_layer(430, 90, "UI_Instances", obj_button);
        discard_button.text = "DISCARD";
        discard_button.on_click_event = DISCARD_CARD;

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
    	if (play_button != undefined) {
        	play_button.disabled = selection_price > global.currency || array_length(selected_cards) <= 0;
    	}
    	
    	if (discard_button != undefined) {
	        discard_button.disabled = array_length(selected_cards) <= 0;
    	}
    	
        upgrade_banner_y = lerp(upgrade_banner_y, target_upgrade_banner_y, 0.2);
        
        if (input_check_pressed("select")) {
        	fsm.change("progress_to_next_draw");
        }
    },
    draw: function() {
		draw_card_meter();
		banner(upgrade_banner_height, upgrade_banner_y, "SELECT CARDS: LEFT-CLICK | CLOSE MENU: R", BLACK, 0.6);
		draw_shadow_text(room_width/2, room_height/2 - 90, "MANA COST: " + string(selection_price), global.currency >= selection_price ? WHITE : RED, PURPLE);
		if (got_lucky_draw) {
			draw_shadow_text(room_width/2, room_height/2 - 120, "LUCKY DRAW!", YELLOW, PURPLE);
		}
	},
	leave: function() {
		got_lucky_draw = false;
	}
});

fsm.add("view_discard_pile", {
    enter: function() {
    	selected_cards = [];
    	selection_price = 0;
    	
        var _card_margin = 30;
        
        // Pause all characters in the scene
        publish(ACTORS_DEACTIVATED);
        physics_pause_enable(true);
        
        // Spawn retrieve button
        retrieve_button = instance_create_layer(room_width/2, 90, "UI_Instances", obj_button);
        retrieve_button.x -= retrieve_button.width/2;
		retrieve_button.text = "RETRIEVE";
        retrieve_button.on_click_event = RETRIEVE_CARD;
		
		// Spawn card_obj_instances
        var _start_x = room_width/2;
        var _section_width = 0;
        for (var _i = 0; _i < array_length(discard_pile); _i++) {
        	
        	// Base position for card
        	var _card = instance_create_layer(x, y, "UI_Instances", obj_card);
        	_card.x = _start_x + ((sprite_get_width(_card.sprite_index) + _card_margin/2) * _i);
        	_card.y = starting_card_section_y;
        	_card.starting_y = _card.y;
        	_card.target_y = card_section_y;
        	_card.resting_y = card_section_y;
        	_card.time_until_active = 10 * _i;
        	_section_width += sprite_get_width(_card.sprite_index) + _card_margin;
        	
        	// Upgrade data for card
        	var _upgrade = discard_pile[_i];
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
        
        if (retrieve_button != undefined) {
        	retrieve_button.disabled = array_length(selected_cards) <= 0;
        }
        
        if (input_check_pressed("view_discard_pile")) {
        	fsm.change("progress_to_next_draw");
        }
    },
    draw: function() {
		draw_card_meter();
		banner(upgrade_banner_height, upgrade_banner_y, "DISCARD PILE", BLACK, 0.6);
		draw_shadow_text(room_width/2, room_height/2 - 90, "RETRIEVE UP TO: " + string(retrieve_count), WHITE, PURPLE);
		draw_shadow_text(room_width/2, upgrade_banner_y + (upgrade_banner_height * 0.90), "(press Q to close)");
	},
	leave: function() {
		if (retrieve_button != undefined) {
	    	instance_destroy(retrieve_button);
	    }
	    
		with (obj_card) {
			instance_destroy(self);
		}
		card_obj_instances = [];
	    
	    selected_cards = [];
	}
});

fsm.add("draw_card", {
    enter: function() {
    	hand_full = array_length(hand) >= hand_size_limit;
    	
    	if (upgrade_progress_points >= draw_score && !hand_full) {
        	// Roll a chance for the player to get a lucky draw
        	var _excess_points = max(upgrade_progress_points - draw_score, 0);
        	var _excess_points_percentage = min(_excess_points/draw_score, 1);
        	var _random_chance = random_range(0, 100);
        	
        	got_lucky_draw = _random_chance <= (_excess_points_percentage * 100);
        	if (got_lucky_draw) {
        		lucky_draw_new_card();
        	}
        	else {
        		draw_new_card();
        	}
        	
        	// Increase target points for next upgrade; reset progress
        	draw_score *= 2;
        	upgrade_progress_points = 0;
        	
        	// Show player their new hand after drawing
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
    	draw_card_meter();
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
		draw_card_meter();
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
		draw_new_card();
	}
}

draw_new_card = function() {
	if (array_length(hand) < hand_size_limit && array_length(deck) > 0) {
		var _struct_deck = build_deck_of_structs(deck);
		var _upgrade_struct = get_weighted_random_card(_struct_deck);
		var _upgrade = get_upgrade_type(_upgrade_struct.key);
    	array_push(hand, _upgrade);
    	remove_from_temp_deck(_upgrade_struct);
	}
}

lucky_draw_new_card = function() {
	if (array_length(hand) < hand_size_limit && array_length(deck) > 0) {
		var _struct_deck = build_deck_of_structs(deck);
		var _upgrade_struct = get_weighted_rare_card(_struct_deck);
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
		var _discarded_card = hand[_card_to_remove_index];
		array_push(discard_pile, _discarded_card);
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

check_if_card_selected = function(_card) {
	var _found_card = false;
	
	FOREACH selected_cards ELEMENT
		if (_card == _elem) {
			_found_card = true;
		}
	END
	
	return _found_card;
}

// -- Randomly select cards for your starting hand 
generate_card_hand();

// Event Subscriptions
subscribe(id, CARD_SELECTED, function(_payload = {}) {
	var _price = struct_get(_payload, "price");
	var _card = struct_get(_payload, "card_data");
	var _card_instance = struct_get(_payload, "card_instance");
	var _selected = check_if_card_selected(_card_instance);
	
	// if already selected,
	if (!_selected) {
		
		// only allow card selection if we're under the limit of selected cards to retrieve
		if (fsm.get_current_state() == "view_discard_pile") {
			if (retrieve_count > 0) {
				retrieve_count -= 1;
			}
			else {
				return;
			}
		}
		
		// 
		selection_price += _price;
		
		array_push(selected_cards, _card_instance);
		
		_card_instance.selected = true;
	} 
	// if not already selected,
	else {
		if (fsm.get_current_state() == "view_discard_pile") {
			retrieve_count += 1;
		}
	
		selection_price -= _price;
		
		var _selected_card_index = 0;
		FOREACH selected_cards ELEMENT
			if (_elem == _card_instance) {
				_selected_card_index = _i;
			}
		END
		array_delete(selected_cards, _selected_card_index, 1);
		
		_card_instance.selected = false;
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

subscribe(id, PLAYED_CARD, function() {
	if (global.currency >= selection_price && array_length(selected_cards) > 0) {
		global.currency -= selection_price;
	}
	else {
		return;
	}
	
	var _go_to_discard_pile = false;
	
	// iterate over selected cards
	FOREACH selected_cards ELEMENT
		var _card = _elem.upgrade;
		
		// certain effects need to be implemented within the card selection UI
		FOREACH _card.effects ELEMENT
			var _effect = _elem;
			
			if (_effect.property == "retrieve_discard_pile") {
				// add the card's value to the retrieve_count number
				retrieve_count += _effect.value;
				
				// set boolean to check when we want to move to discard pile UI
				_go_to_discard_pile = true;
			}
		END
		
		// for each card, publish upgrade event with the card's data
		publish(UPGRADE_SELECTED, _card);
		
		// for each card, discard the card data from your hand
		discard_card(_card);
		
	END
	
	// destroy all card object instances
	with (obj_card) {
		instance_destroy(self);
	}
	card_obj_instances = [];
	
	// destroy all button instances
	instance_destroy(play_button);
	instance_destroy(discard_button);
	
	// restart view hand state to regenerate hand
	if (_go_to_discard_pile) {
		fsm.change("view_discard_pile");
	} else {
		fsm.change("view_hand");
	}
});

subscribe(id, DISCARD_CARD, function() {
	if (array_length(selected_cards) <= 0) {
		return;
	}
	
	// iterate over selected cards
	FOREACH selected_cards ELEMENT
		// for each card, discard the card data from your hand
		var _card = _elem.upgrade;
		var _extra_mana = _card.price/4;
		global.currency += _extra_mana;
		var _score_text = instance_create_layer(room_width/2, room_height/2, layer, obj_float_text);
		_score_text.text = "+" + string(_extra_mana);
		_score_text.text_sprite = spr_mana_icon;
		draw_set_font(_score_text.text_font);
		_score_text.text_sprite_offset_x = (-1 * string_width(_score_text.text)/2)-4;
		discard_card(_card);
	END
	play_sound(snd_points, false);
	
	// destroy all card object instances
	with (obj_card) {
		instance_destroy(self);
	}
	card_obj_instances = [];
	
	// destroy all button instances
	instance_destroy(play_button);
	instance_destroy(discard_button);
	
	// restart view hand state to regenerate hand 
	fsm.change("view_hand");
});

subscribe(id, RETRIEVE_CARD, function() {
	// for each selected card
	FOREACH selected_cards ELEMENT
	
		// get the struct card data
		var _selected_card = _elem.upgrade;
		
		// add to hand array (similar to draw method)
		array_push(hand, _selected_card);
		
		// remove from discard pile
		var _discard_pile_index = 0;
		for (var _j = 0; _j < array_length(discard_pile); _j++) {
			var _discarded_card = discard_pile[_j];
			if (_discarded_card.key == _selected_card.key) {
				_discard_pile_index = _j;
			}
		}
		array_delete(discard_pile, _discard_pile_index, 1);
		
	END
	
	// go back to view hand state
	fsm.change("view_hand");
});
