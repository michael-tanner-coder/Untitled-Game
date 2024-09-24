// particles
particle_system = part_system_create();
dust_particles = part_type_create();
spark_particles = part_type_create();
puff_particles = part_type_create();
trail_particles = part_type_create();
beam_particles = part_type_create();
inward_particles=part_type_create();

// dust
part_type_sprite(dust_particles, spr_circle, 0,0,1);
part_type_size(dust_particles, 0.25, 0.75, 0.001, 0);
part_type_direction(dust_particles, 45, 135, 0, 1);
part_type_speed(dust_particles, 0.1, 0.4, -0.004, 0);
part_type_life(dust_particles, 50, 70);
part_type_orientation(dust_particles, 0, 359, 0.1,1,0);
part_type_alpha3(dust_particles, 0.5, 1, 0.01);

// puffs
part_type_sprite(puff_particles, spr_circle, 0,0,1);
part_type_size(puff_particles, 0.5,1, 0.001, 0);
part_type_direction(puff_particles, 0, 359, 0, 1);
part_type_speed(puff_particles, 0.1, 0.2, -0.004, 0);
part_type_life(puff_particles, 50,70);
part_type_orientation(puff_particles, 0, 359, 0.1,1,0);
part_type_alpha3(puff_particles, 0.1, 0.2,0.01);

// sparkles
part_type_sprite(spark_particles, spr_star, 0,0,1);
part_type_size(spark_particles, 0.25, 0.75, 0.001, 0);
part_type_direction(spark_particles, 0, 359, 0, 1);
part_type_speed(spark_particles, 1, 2, -0.004, 0);
part_type_life(spark_particles, 20,50);
part_type_alpha3(spark_particles, 1, 0.5,0.01);
part_type_gravity(spark_particles, 0.25, 90);

// beam particles
part_type_sprite(beam_particles, spr_circle_blur, 0,0,1);
part_type_size(beam_particles, 0.25, 0.75, 0.001, 0);
part_type_direction(beam_particles, 0, 359, 0, 1);
part_type_speed(beam_particles, 1, 2, -0.004, 0);
part_type_life(beam_particles, 20,50);
part_type_alpha3(beam_particles, 1, 0.5,0.01);
part_type_blend(beam_particles, true);
part_type_gravity(beam_particles, 0.25, 90);

// trails
part_type_sprite(trail_particles, spr_empty, 0, 0, 1);
part_type_size(trail_particles, 1, 1, 0, 0);
part_type_life(trail_particles, 20, 20);
part_type_alpha3(trail_particles, 0.2, 0.1, 0);
part_type_color1(trail_particles, c_white);

// inward particles
part_type_sprite(inward_particles, spr_circle_blur, 0, 0, 1);
part_type_shape(inward_particles, pt_shape_disk);
part_type_speed(inward_particles, 5, 10, .1, 0);
part_type_colour1(inward_particles, c_white);
part_type_life(inward_particles, 10, 10);
part_type_size(inward_particles, .1, .3, -.02, 0);
part_type_blend(beam_particles, true);