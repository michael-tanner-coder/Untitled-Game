standard_enemy_create_event();

// Base
base_speed = 5;
hit_timer = 0;
growth_rate = 1;
max_scale = 8;

// Animation
x_offset = 0;
y_offset = 0;
rolling_spritesheet = spr_exploding_enemy_sheet;

// Physics
radius = 8;
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
			
			if (image_xscale < max_scale/2) {
				point_value /= 2;
			}
			else if (image_xscale >= max_scale * 0.75) {
				point_value *= 2;
			}
			
			mana_value = 10 * image_xscale;
		}
		
		hit_flash_alpha = image_xscale/max_scale;
		if (image_xscale >= max_scale) {
			instance_destroy(self);
		}
		
	},
	draw: function() {
		draw_8_direction_movement(hit ? hit_spritesheet : rolling_spritesheet, frame_width, frame_height, anim_length, image_alpha, image_blend, (frame_width * image_xscale)/2, (frame_height * image_yscale)/2);
		if (hit_flash_alpha > 0) {
			shader_set(sh_flash);
			
			draw_sprite_part_ext(
				hit ? hit_spritesheet : rolling_spritesheet,
				0,
				floor(x_frame) * frame_width,
				floor(y_frame) * frame_height,
				frame_width,
				frame_height,
				floor(x - (frame_width * image_xscale)/2),
				floor(y - (frame_height * image_yscale)/2),
				image_xscale,
				image_yscale, 
				hit_flash_color,
				hit_flash_alpha,
			);
			
			shader_reset();
		}
	
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

// Event Subscriptions
subscribe(id, ACTORS_DEACTIVATED, function() {fsm.change("idle")});
subscribe(id, ACTORS_ACTIVATED, function() {fsm.change("active")});