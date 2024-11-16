standard_enemy_create_event();

image_xscale = 2;
image_yscale = 2;
x_offset = 32 * 4;
y_offset = 32 * 4;
paddle = undefined;
movement_magnitude = 400;
base_stun_time = 40;
point_value = 1000;
paddle = instance_create_layer(x, y, layer, obj_paddle);
paddle.origin = self;

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
    },
    draw: function() {
        draw_self();
        if (global.debug) {
	    	draw_set_color(hit ? RED : BLUE);
			physics_draw_debug();
        }
    }
})