draw_set_font(fnt_cutscene_default);

for(var _i = 0; _i < array_height_2d(items); _i++) {
    for (var _j = 0; _j < array_length_2d(items, _i); _j++) {
        var _item_x = grid_start_x + _j * (grid_item_width + grid_item_margin);
        var _item_y = grid_start_y + _i * (grid_item_height + grid_item_margin);
        _item_y += ((area_height / 100 * obj_slider.percentage) - area_height);
        var _item_width = _item_x + grid_item_width;
        var _item_height = _item_y + grid_item_height;
        var _item = items[_i, _j];
        
        if (_item == undefined) {
            continue;
        }
        
        var _is_highlighted = _j == current_column && _i == current_row;
        
        if (_is_highlighted) {
            with (obj_card) {
                var _upgrade = _item;
            	upgrade = _upgrade;
            	header = _upgrade.name;
            	description = _upgrade.description;
            	price = _upgrade.price;
            	sprite = _upgrade.sprite;
            }
            draw_set_color(RED);
            draw_rectangle(_item_x - grid_item_outline_thickness/2, _item_y - grid_item_outline_thickness/2, _item_width + grid_item_outline_thickness, _item_height + grid_item_outline_thickness, false);
        }
        
        draw_set_color(WHITE);
        draw_rectangle(_item_x, _item_y, _item_width, _item_height, false);
        
        if (is_unlocked({key: _item.key, category: grid_data_category})) {
            draw_set_color(_is_highlighted ? PINK : WHITE);
            draw_sprite_ext(_item.sprite, 0, _item_x + grid_item_width/2, _item_y + grid_item_height/2, 1, 1, 0, c_white, 1);
            draw_set_halign(fa_middle);
            draw_set_valign(fa_top);
            draw_text(_item_x + grid_item_width/2, _item_y + grid_item_height, _item.name);
        }
        else {
            draw_set_color(BLUE);
            draw_set_halign(fa_middle);
            draw_set_valign(fa_center);
            draw_text(_item_x + grid_item_width/2, _item_y + grid_item_height/2, "?");
        }
    }
}