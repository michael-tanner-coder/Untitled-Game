global.level_rooms = [
    rm_combat_test_small,
    rm_combat_test_small_2,
    rm_combat_test_small_3,
    rm_combat_test_small_4,
];
global.level_layouts = [];
global.level_gen_index = 0;
global.current_layout = {};

function start_level_compilation() {
    room_goto(global.level_rooms[global.level_gen_index]);
}

function compile_level_layouts() {
    show_debug_message("compile_level_layouts");
    var _layouts = [];
    var _current_level_struct = {
        blocks: [],
        spawn_points: [],
    };
    
    FOREACH global.level_rooms ELEMENT
    
        var _current_layout_struct = {
            key: "",
            blocks: [],
            spawn_points: [],
        };
    
        room_goto(_elem);
        var _key = room_get_name(room);
        show_debug_message(_key);
        
        with (obj_spike_block) {
            array_push(_current_layout_struct.blocks, {
                x_pos: x,
                y_pos: y,
            });
        }
        
        _current_layout_struct.key = _key;
        
        array_push(_layouts, _current_layout_struct);
        
    END
    
    global.level_layouts = _layouts;
}

function spawn_level_layout(_layout = {}) {
    if (is_array(_layout.blocks)) {
        FOREACH _layout.blocks ELEMENT
            instance_create_layer(_elem.x_pos, _elem.y_pos, layer, obj_spike_block);
        END
    }
    else {
        show_debug_message("Blocks is not an array")
    }
    
   with(obj_dot) {
       instance_destroy(self);
   }
   
   with (obj_money) {
       instance_destroy(self);
   }
}

function destroy_level_layout() {
    with(obj_spike_block) {
        instance_destroy(self);
    }
    
    with(obj_dot) {
       instance_destroy(self);
    }
   
    with (obj_money) {
       instance_destroy(self);
    }
}

function pick_random_level_layout() {
    return global.level_layouts[irandom_range(0, array_length(global.level_layouts) - 1)];
}
