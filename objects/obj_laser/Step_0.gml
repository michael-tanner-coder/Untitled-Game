image_yscale += growth_rate;
physics_remove_fixture(self, my_fixture);
physics_fixture_delete(fix);
fix = physics_fixture_create();
physics_fixture_set_box_shape(fix, 32, 32 * image_yscale);
physics_fixture_set_density(fix, 0);
physics_fixture_set_collision_group(fix, 1);
physics_fixture_set_restitution(fix, 0.875);
physics_fixture_set_linear_damping(fix, 0.1);
physics_fixture_set_angular_damping(fix, 0.1);
physics_fixture_set_friction(fix, 0.4);
my_fixture = physics_fixture_bind(fix, self);

lifespan--;
if (lifespan < 0) {
	spawn_particles(part_death, x, y);
	instance_destroy(self);
}