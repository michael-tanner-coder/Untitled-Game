standard_enemy_create_event();

// Standard Properties
image_xscale = 2;
image_yscale = 2;
x_offset = 32 * 4;
y_offset = 32 * 4;
movement_magnitude = 1000;
base_stun_time = 40;
point_value = 1000;

// Chain Properties
segments = 5;
segment_rope_length = 32;
chains_count = 3;
chain = [];
chains = [];

// TODO: give the boss more chains on each life
// TODO: space apart the chains by a certain angle
// TODO: check if joints exist before drawing them
// TODO: allow ropes to be broken with enough force
// TODO: play with the weight of the segments

spawn_chain_segments = function() {
	chains = [];
	
	for (var _j = 0; _j < chains_count; _j++) {
		var _chain = [];
		
		for(var _i = 0; _i < segments; _i++){
			// spawn segment at an offset value (x/y + height of previous segment/head)
			var _spawn_pos = {x_pos: 0, y_pos: sprite_get_height(sprite_index)};
			var _segment = instance_create_layer(x + _spawn_pos.x_pos, y + _spawn_pos.y_pos, layer, obj_chain_segment);
			
			// make the first segment target the head
			_segment.target = NO_FOLLOW;
		
			// make all other segments target the most recently spawned segment
			if (array_length(_chain) > 0) {
				_segment.joint = physics_joint_rope_create(_chain[_i-1], _segment, _chain[_i-1].x, _chain[_i-1].y, _segment.x, _segment.y, segment_rope_length, false);
			} else {
				_segment.joint = physics_joint_rope_create(self, _segment, x, y, _segment.x, _segment.y, segment_rope_length, false);
			}
			
			// add segment to the array 
			array_push(_chain, _segment);
		}
		
		array_push(chains, _chain);
	}
}

reset_chain_segments = function() {}

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
        // var _existing_segments = [];
        // FOREACH chain ELEMENT
        // 	var _segment = _elem;
        // 	if (instance_exists(_segment)) {
        // 		array_push(_existing_segments, _segment);
        // 	}
        // END
        // chain = _existing_segments;
        
        // give each segment a new target if any have been destroyed
        // for(var _i = 0; _i < array_length(chain); _i++) {
        // 	var _segment = chain[_i];
        	
	       // 	_segment.target = NO_FOLLOW;
	        	
	       // 	if (_i > 0) {
	       // 		// _segment.target = chain[_i-1];
	       // 		physics_joint_rope_create(self, _segment, x, y, _segment.x, _segment.y, segment_rope_length, false);
	       // 	} else {
	       // 		physics_joint_rope_create(chain[_i-1], _segment, chain[_i-1].x, chain[_i-1].y, _segment.x, _segment.y, segment_rope_length, false);
	       // 	}
        // }
    },
    draw: function() {
        draw_self();
        
        if (global.debug) {
	    	draw_set_color(hit ? RED : BLUE);
			physics_draw_debug();
        }
        
    //     FOREACH chain ELEMENT
    //     	var _segment = _elem;
    //     	if (instance_exists(_segment) && instance_exists(_segment.joint)) {
				// var _anchor_1_x = physics_joint_get_value(_segment.joint, phy_joint_anchor_1_x);
				// var _anchor_1_y = physics_joint_get_value(_segment.joint, phy_joint_anchor_1_y);
				// var _anchor_2_x = physics_joint_get_value(_segment.joint, phy_joint_anchor_2_x);
				// var _anchor_2_y = physics_joint_get_value(_segment.joint, phy_joint_anchor_2_y);
				// var _width = abs(_anchor_1_x - _anchor_2_x);
				// var _height = abs(_anchor_1_y - _anchor_2_y);
				// var _angle = point_direction(_anchor_1_x, _anchor_1_y, _anchor_2_x, _anchor_2_y);
				// draw_sprite_ext(spr_joint, 0, _anchor_1_x + _width/2, _anchor_1_y + _height/2, _width, _height, _angle, RED, 1);
    //     	}
    //     END
    }
})