// menu navigation
var _direction = "down";

if (input_check_pressed("right")) {
    _direction = "right";
    current_column++;
}

if (input_check_pressed("left")) {
    _direction = "left";
    current_column--;
}

if (input_check_pressed("down")) {
    _direction = "down";
    current_row++;
}

if (input_check_pressed("up")) {
    _direction = "up";
    current_row--;
}

current_column = loop_clamp(current_column, 0, columns-1);
current_row = loop_clamp(current_row, 0, array_height_2d(items)-1);

var _next_cell = items[current_row, current_column];
if (_direction != "" && _next_cell == undefined) {
    if (_direction == "right") {
        current_column = 0;
    }
    
    if (_direction == "down") {
        current_row = 0;
    }
    
    if (_direction == "left")  {
        while (_next_cell == undefined) {
            current_column--;
            _next_cell = items[current_row, current_column];
        }
    }
}