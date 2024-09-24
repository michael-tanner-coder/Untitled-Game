
cell_size = 32;
grid = mp_grid_create(0, 0, room_width/cell_size, room_height/cell_size, cell_size, cell_size);

rebuild_grid = function() {
    mp_grid_destroy(grid);
    grid = mp_grid_create(0, 0, room_width/cell_size, room_height/cell_size, cell_size, cell_size);
    mp_grid_add_instances(grid, obj_ground, 0);
}

rebuild_grid();

subscribe(id, GRID_REBUILT, rebuild_grid);