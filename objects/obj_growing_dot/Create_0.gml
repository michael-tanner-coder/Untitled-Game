standard_enemy_create_event();

// Base
base_speed = 5;
hit_timer = 0;
growth_rate = 0.25;
max_scale = 8;

// Animation
x_offset = 0;
y_offset = 0;
rolling_spritesheet = spr_growing_enemy_sheet;
radius = 8;

// Physics
my_fixture = create_circle_fixture(radius, 0.5, 1, 0.875, 0.1, 0.1, 0.4);

// State Machine
fsm = new SnowState("active");

fsm.add("active", {
	step: function() {
		standard_enemy_step_event();
		
		// increase size over time
		if (image_xscale < max_scale && image_yscale < max_scale) {
			// Sprite change
			var _dt = delta_time / 1000000;
			image_xscale += _dt * growth_rate;
			image_yscale += _dt * growth_rate;
			
			// Physics update
			physics_remove_fixture(self, my_fixture);
			physics_fixture_delete(fix);
			my_fixture = create_circle_fixture(radius * image_xscale, 0.5 * image_xscale, 1, 0.875, 0.1, 0.1, 0.4)
			point_value = image_xscale * 200;
		}
	},
	
	draw: function() {
		draw_8_direction_movement(hit ? hit_spritesheet : rolling_spritesheet, frame_width, frame_height, anim_length, image_alpha, image_blend, (frame_width * image_xscale)/2, (frame_height * image_yscale)/2);
		
		if (global.debug) {
			draw_set_color(BLUE);
			physics_draw_debug();
		}
	}
});

fsm.add("idle", {
	step: function() {},
	draw: function() {
		draw_8_direction_movement(hit ? hit_spritesheet : rolling_spritesheet, frame_width, frame_height, anim_length, image_alpha, image_blend, (frame_width * image_xscale)/2, (frame_height * image_yscale)/2);
		
		if (global.debug) {
			draw_set_color(BLUE);
			physics_draw_debug();
		}
	}
});