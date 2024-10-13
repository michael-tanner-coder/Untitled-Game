if (room == rm_level_generation) {
    room_goto(global.level_rooms[global.level_gen_index]);   
    return;
}

if (!array_contains(global.level_rooms, room)) {
    return;
}

show_debug_message("compile_level_layouts");

var _current_level_struct = {
    blocks: [],
    spawn_points: [],
};

var _current_layout_struct = {
    key: "",
    blocks: [],
    spawn_points: [],
};

var _key = room_get_name(room);
show_debug_message(_key);

with (obj_wall) {
    array_push(_current_layout_struct.blocks, {
        x_pos: x,
        y_pos: y,
    });
}

_current_layout_struct.key = _key;

array_push(global.level_layouts, _current_layout_struct);

global.level_gen_index += 1;

if (global.level_gen_index > array_length(global.level_rooms) - 1) {
    room_goto(rm_main_menu);
    instance_destroy(self);
}
else {
    room_goto(global.level_rooms[global.level_gen_index]);
}