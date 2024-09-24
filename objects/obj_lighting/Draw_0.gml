if (surface_exists(light_surf)) {
    surface_set_target(light_surf);
    draw_clear(c_black);
    
    gpu_set_blendmode(bm_subtract);
    draw_self();
    
    gpu_set_blendmode(bm_normal);
    draw_self();
    
    surface_reset_target();
    draw_surface_ext(light_surf, 0, 0, 1, 1, 0, WHITE, darkness);
}
else {
    light_surf = surface_create(room_width, room_height);
}