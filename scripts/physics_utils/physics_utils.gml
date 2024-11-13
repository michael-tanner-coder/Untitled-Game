function create_circle_fixture(_radius = 16, _density = 0.5, _group = 1, _restitution = 0.875, _linear_damping = 0.1, _angular_damping = 0.1, _friction = 0.4) {
    fix = physics_fixture_create();
    physics_fixture_set_circle_shape(fix, _radius);
    physics_fixture_set_density(fix, _density);
    physics_fixture_set_collision_group(fix, _group);
    physics_fixture_set_restitution(fix, _restitution);
    physics_fixture_set_linear_damping(fix, _linear_damping);
    physics_fixture_set_angular_damping(fix, _angular_damping);
    physics_fixture_set_friction(fix, _friction);
    return physics_fixture_bind(fix, self);
}