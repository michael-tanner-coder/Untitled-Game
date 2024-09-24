grid_start_x = 0;
grid_start_y = 0;

// grid navigation
current_row = 0;
current_column = 0;

// grid dimensions
rows = 3;
columns = 3;

// grid data
data_source = undefined;
grid_data_category = "powerups";
items[0] = [];

// grid item dimensions/spacing
grid_item_width = 200;
grid_item_height = 200;
grid_item_margin = 70;
grid_item_outline_thickness = 6;

area_height = (grid_item_height + grid_item_margin) * 3;

// grid methods
function populate_grid() {
    if (is_array(data_source)) {
        var _row = 0;
        var _col = 0;
        FOREACH data_source ELEMENT
            array_push(items[_row], _elem);
            _col++;
            if (_col >= columns) {
                _col = 0;
                _row++;
                array_push(items, []);
            }
        END
        
        if (_col < columns-1) {
            for (var _i = _col; _i <= columns-1; _i++) {
                array_push(items[_row], undefined);
            }
        }
    }
    
    show_debug_message("populate_grid");
    show_debug_message(items);
}

function position_grid() {
    var _full_grid_width = columns * (grid_item_width + grid_item_margin);
    grid_start_x = (room_width/2) - (_full_grid_width/2);
    grid_start_y = y;
}

position_grid();