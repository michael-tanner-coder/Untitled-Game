max_enemy_count = 1;
time_between_spawns = 30;
spawn_timer = 30;
previous_spawn_point = {x_pos: 0, y_pos: 0};

var _temp_spawn_points = [];
with(obj_dot) {
    array_push(_temp_spawn_points, {x_pos: x, y_pos: y});
    
    instance_destroy(self);
}
spawn_points = _temp_spawn_points;