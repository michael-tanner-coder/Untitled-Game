image_speed = 1;
var _flash = instance_create_layer(x,y,layer,obj_muzzle_flash);
_flash.depth = depth - 1;

// Physics Fixture
fix = physics_fixture_create();
physics_fixture_set_circle_shape(fix, 16);
physics_fixture_set_density(fix, 0.5);
physics_fixture_set_collision_group(fix, 1);
physics_fixture_set_restitution(fix, 0.1);
physics_fixture_set_linear_damping(fix, 0.1);
physics_fixture_set_angular_damping(fix, 0.1);
physics_fixture_set_friction(fix, 0.2);
physics_fixture_set_sensor(fix, false);
my_fixture = physics_fixture_bind(fix, self);