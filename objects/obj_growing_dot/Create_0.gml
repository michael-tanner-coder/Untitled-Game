xspd = 0;
yspd = 0;
base_speed = 5;
hit = false;
hit_timer = 0;
growth_rate = 0.25;
max_scale = 4;
point_value = 100;
x_force = 0;
y_force = 0;
shield_sprite = spr_shield;

// Physics fixture
fix = physics_fixture_create();
physics_fixture_set_circle_shape(fix, 16);
physics_fixture_set_density(fix, 0.5);
physics_fixture_set_collision_group(fix, 1);
physics_fixture_set_restitution(fix, 0.875);
physics_fixture_set_linear_damping(fix, 0.1);
physics_fixture_set_angular_damping(fix, 0.1);
physics_fixture_set_friction(fix, 0.4);
my_fixture = physics_fixture_bind(fix, self);

shadow = instance_create_layer(x,y,layer,obj_shadow);
shadow.depth = depth + 1;
shadow.owner = self;