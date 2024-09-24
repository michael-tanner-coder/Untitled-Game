if (purchasing_disabled) {
    return;
}

if (show_discard_item_prompt) {
    if (input_check_pressed("cancel")) {
        show_discard_item_prompt = false;
        item_to_purchase = {};
        item_to_discard = {};
    }
    
    item_to_discard = move_cursor(global.powerups_spawn_list);
    
    if (input_check_pressed("select")) {
        remove_item_from_spawn_list(item_to_discard.key);
        purchase_item(item_to_purchase);
        show_discard_item_prompt = false;
    }
    
    return;    
}

if (input_check_pressed("cancel")){
    go_to_next_scene();
}

current_item = move_cursor(shop_items);

if (array_length(shop_items) <= 0) {
    instance_destroy(current_item_description_box);
}

if (current_item != undefined && instance_exists(current_item_description_box)) {
    current_item_description_box.header_text = current_item.name;
    current_item_description_box.tip_text = string(current_item.price);
}

if (current_item != undefined && input_check_pressed("select")) {
    purchase_item(current_item);
}

FOREACH shop_item_instances ELEMENT 
    if (!instance_exists(_elem)) {
        array_delete(shop_item_instances, _i, 1);
    }
    else {
        var _shop_position_x = start_x + (_i * (sprite_get_width(box) + item_margin));
        _elem.x = lerp(_elem.x, _shop_position_x, 0.1);
    }
END