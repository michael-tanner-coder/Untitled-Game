standard_enemy_create_event();

image_xscale = 8;
image_yscale = 8;
x_offset = 32 * 4;
y_offset = 32 * 4;
paddle = undefined;

fsm.add("active", {
    enter: function() {
		publish(SPAWNED_BOSS);
		paddle = instance_create_layer(x, y, layer, obj_paddle);
		paddle.origin = self;
	},
    step: function() {
        standard_enemy_step_event();
    },
    draw: function() {
        // standard_enemy_draw_event();
	    draw_set_color(BLUE);
		if (global.debug) {
			draw_set_color(BLUE);
			physics_draw_debug();
		}
    }
})