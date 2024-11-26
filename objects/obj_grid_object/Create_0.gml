data_item = undefined;
data_instance_struct = {key: "", id: 0};
bg_sprite = spr_grid_item;
data_sprite = spr_grid_item;
data_name = "GRID BLOCK";
highlighted = false;
default_color = WHITE;
fill_color = WHITE;
text_margin = 10;

subscribe(id, "scroll", function(_direction = "") {
    if (_direction == "up") {
        y += sprite_get_height(sprite_index);
    }
   
    if (_direction == "down") {
        y -= sprite_get_height(sprite_index);
    }
})