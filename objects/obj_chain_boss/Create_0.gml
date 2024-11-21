standard_enemy_create_event();

// Standard Properties
image_xscale = 2;
image_yscale = 2;
x_offset = 32 * 4;
y_offset = 32 * 4;
movement_magnitude = 500;
base_stun_time = 40;
point_value = 1000;

// Chain Properties
segments = 5;
segment_rope_length = 32;
chain = [];

// TODO: give the boss more chains on each life
// TODO: extend the rope length to give the player an easier time beating the segments
// TODO: play with the weight of the segments
// TODO: consider not using the "target" system

spawn_chain_segments = function() {
	for(var _i = 0; _i < segments; _i++){
		// spawn segment at an offset value (x/y + height of previous segment/head)
		var _segment = instance_create_layer(x, y + sprite_get_height(sprite_index), layer, obj_chain_segment);
		
		// make the first segment target the head
		_segment.target = self;
	
		// make all other segments target the most recently spawned segment
		if (array_length(chain) > 0) {
			_segment.target = chain[_i-1];
			physics_joint_rope_create(chain[_i-1], _segment, chain[_i-1].x, chain[_i-1].y, _segment.x, _segment.y, segment_rope_length, false);
		} else {
			physics_joint_rope_create(self, _segment, x, y, _segment.x, _segment.y, segment_rope_length, false);
		}
		
		// add segment to the array 
		array_push(chain, _segment);
	}
}

spawn_chain_segments();

// State Machine
fsm.add("active", {
    enter: function() {
		publish(SPAWNED_BOSS);
	},
    step: function() {
        standard_enemy_step_event();
        phy_rotation = 0;
        
        if (hit) {
        	sprite_index = spr_paddle_boss_hit;
        }
        else {
        	sprite_index = spr_paddle_boss;
        }
        
        // boss can only be defeated when chain is gone
        if (array_length(chain) > 0) {
			hit = false;
			hit_timer = 0;
		}
        
        // clean up chain array if any segments have been destroyed
        var _existing_segments = [];
        FOREACH chain ELEMENT
        	var _segment = _elem;
        	if (instance_exists(_segment)) {
        		array_push(_existing_segments, _segment);
        	}
        END
        chain = _existing_segments;
        
        // give each segment a new target if any have been destroyed
        for(var _i = 0; _i < array_length(chain); _i++) {
        	var _segment = chain[_i];
        	
        	if (!instance_exists(_segment.target)) {
	        	_segment.target = self;
	        	
	        	if (_i > 0) {
	        		_segment.target = chain[_i-1];
	        		physics_joint_rope_create(self, _segment, x, y, _segment.x, _segment.y, segment_rope_length, false);
	        	} else {
	        		physics_joint_rope_create(chain[_i-1], _segment, chain[_i-1].x, chain[_i-1].y, _segment.x, _segment.y, segment_rope_length, false);
	        	}
        	}
        }
    },
    draw: function() {
        draw_self();
        if (global.debug) {
	    	draw_set_color(hit ? RED : BLUE);
			physics_draw_debug();
        }
    }
})