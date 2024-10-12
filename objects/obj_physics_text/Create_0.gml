text="MADE BY MICHAEL MONTY";
font = fnt_default;
hit = false;
hit_timer = 0;
text_alpha = 0;

// Physics Fixture
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
