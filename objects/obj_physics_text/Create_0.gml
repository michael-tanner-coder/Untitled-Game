text="MADE BY MICHAEL MONTY";
font = fnt_default;
hit = false;
hit_timer = 0;
text_alpha = 0;
max_text_health = 10;
text_health = max_text_health;
point_value = 200;
default_text_color = WHITE;
hit_text_color = PURPLE;
shake_x_offset = 0;
shake_y_offset = 0;
shake_magnitude = 0;
shake_time = 0;
shake_fade = 0;
shake = false;

// Physics Fixture Methods
remove_previous_fixture = function() {
    physics_remove_fixture(self, my_fixture);
	physics_fixture_delete(fix);
}

set_physics_fixture = function() {
    fix = physics_fixture_create();
    draw_set_font(font);
    var _width = string_width(text);
    var _height = string_height(text);
    physics_fixture_set_box_shape(fix, _width/2, _height/2);
    physics_fixture_set_density(fix, 0.5);
    physics_fixture_set_collision_group(fix, 1);
    physics_fixture_set_restitution(fix, 0);
    physics_fixture_set_linear_damping(fix, 0.2);
    physics_fixture_set_angular_damping(fix, 0.2);
    physics_fixture_set_friction(fix, 0.1);
    my_fixture = physics_fixture_bind(fix, self);
};

set_physics_fixture();

// Text Methods
set_text_color_from_health = function() {
	if (text_health <= max_text_health * 0.8) {
		default_text_color = YELLOW;
	}
	
	if (text_health <= max_text_health * 0.5) {
		default_text_color = ORANGE;
	}

	if (text_health <= max_text_health * 0.25) {
		default_text_color = RED;
	}
}

shake_text = function(_time = 0, _magnitude = 0, _fade_rate = 0) {
	shake_time = _time;
	shake_magnitude = _magnitude;
	shake_fade = _fade_rate;
	shake = true;
}
