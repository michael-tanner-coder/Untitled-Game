standard_enemy_create_event();

image_xscale = 8;
image_yscale = 8;
x_offset = 32 * 4;
y_offset = 32 * 4;

fsm.add("active", {
    enter: function() {
		publish(SPAWNED_BOSS);
	},
    step: function() {
        standard_enemy_step_event();
    },
    draw: function() {
        standard_enemy_draw_event();
    }
})