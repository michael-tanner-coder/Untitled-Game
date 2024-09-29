radius = 128;
image_xscale = 0.1;
image_yscale = 0.1;

// Physics fixture
fix = physics_fixture_create();
physics_fixture_set_circle_shape(fix, sprite_get_width(sprite_index) * image_xscale);
physics_fixture_set_density(fix, 0);
physics_fixture_set_collision_group(fix, 1);
physics_fixture_set_restitution(fix, 0.875);
physics_fixture_set_linear_damping(fix, 0.1);
physics_fixture_set_angular_damping(fix, 0.1);
physics_fixture_set_friction(fix, 0);
my_fixture = physics_fixture_bind(fix, self);