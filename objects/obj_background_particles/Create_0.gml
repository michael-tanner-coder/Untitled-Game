part_system = part_system_create_layer("MidLights", false);
part_emitter = part_emitter_create(part_system);
part_type = part_type_create();

part_emitter_region(part_system, part_emitter, 0, display_get_width(), 0, display_get_height(), ps_shape_rectangle, ps_distr_linear);
part_emitter_stream(part_system, part_emitter, part_type, 1);

part_type_alpha3(part_type, 0,1,0);
part_type_color3(part_type, WHITE, WHITE, WHITE);
part_type_life(part_type, game_get_speed(gamespeed_fps) * 2, game_get_speed(gamespeed_fps) * 2.5);
part_type_scale(part_type, 0.25, 0.25);
part_type_direction(part_type, 80, 100, 1, 5);
part_type_sprite(part_type, spr_circle_blur, false, false, false);
part_type_gravity(part_type, 0.01, 90);