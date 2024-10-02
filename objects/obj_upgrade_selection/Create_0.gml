
// Configuration Properties
// upgrade parameters
upgrade_score = 1000; // make this configurable
available_upgrades = [];
upgrade_count = 3;

// card section
cards = [];
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
fsm = new SnowState("progress_to_next_upgrade");

fsm.add("progress_to_next_upgrade", {
    enter: function() {
        publish(ACTORS_ACTIVATED);
        physics_pause_enable(false);
        
        FOREACH cards ELEMENT
        	instance_destroy(_elem);
        END

		cards = [];
        available_upgrades = [];
    },
    step: function() {
        if (upgrade_progress_points >= upgrade_score && keyboard_check_pressed(vk_space)) {
            fsm.change("select_upgrade");
        }
    },
   	draw: function() {
   		if (upgrade_progress_points >= upgrade_score) {
   			banner(50, room_height/6, "PRESS SPACEBAR TO UPGRADE", BLACK, 0.6);
   		}
   		var _bar_bg_color = upgrade_progress_points >= upgrade_score ? WHITE : PURPLE;
		fillbar(progress_bar_x, progress_bar_y, 200, 25, min((upgrade_progress_points/upgrade_score), 1), RED, _bar_bg_color);
		draw_set_halign(fa_center);
	}
});

fsm.add("select_upgrade", {
    enter: function() {
    	// Increase target points for next upgrade; reset progress
        upgrade_score *= 2;
        upgrade_progress_points = 0;
        var _card_margin = 30;
        
        // Pause all characters in the scene
        publish(ACTORS_DEACTIVATED);
        physics_pause_enable(true);
        
        // Randomly select up to 3 upgrade options
        generate_upgrade_options();

		// Spawn upgrade cards
        var _start_x = room_width/2;
        var _section_width = 0;
        for (var _i = 0; _i < array_length(available_upgrades); _i++) {
        	
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
        	var _upgrade = available_upgrades[_i];
        	_card.upgrade = _upgrade;
        	_card.header = _upgrade.name;
        	_card.description = _upgrade.description;
        	_card.sprite = _upgrade.sprite;
        	
        	// Cache all cards for disposal later
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
        upgrade_banner_y = lerp(upgrade_banner_y, target_upgrade_banner_y, 0.2);
    },
    draw: function() {
    	fillbar(progress_bar_x, progress_bar_y, 200, 25,1, RED, WHITE);
		banner(upgrade_banner_height, upgrade_banner_y, "SELECT AN UPGRADE", BLACK, 0.6);
	}
});

// Methods
generate_upgrade_options = function() {
	for (var _i = 0; _i < upgrade_count; _i++) {
		var _upgrade_was_already_chosen = false;
		
		do {
			var _upgrade = global.upgrades[irandom_range(0, array_length(global.upgrades) - 1)];
        	
        	_upgrade_was_already_chosen = false;
        	FOREACH available_upgrades ELEMENT
        		if (_elem.key == _upgrade.key) {
        			_upgrade_was_already_chosen = true;
        		}
        	END
			
			if (!_upgrade_was_already_chosen) {
        		array_push(available_upgrades, _upgrade);
			}
		} until (_upgrade_was_already_chosen == false)
			
	}
}

// Event Subscriptions
subscribe(id, UPGRADE_SELECTED, function() {fsm.change("progress_to_next_upgrade")});
subscribe(id, ENEMY_DEFEATED, function(_points = 0) {
	upgrade_progress_points += _points;
})