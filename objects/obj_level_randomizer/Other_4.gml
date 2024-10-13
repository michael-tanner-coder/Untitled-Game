if (!global.first_wave_complete) {
    global.current_layout = global.level_layouts[0];
}
else {
    global.current_layout = pick_random_level_layout();
}

spawn_level_layout(global.current_layout);