depth = 199;
shop_items = [];
shop_item_instances = [];
shop_inventory_limit = 3;
cursor = 0;
current_item = {};
cursor_movement_rate = 0.2;
box = spr_rounded_box;
cursor_icon = spr_shop_cursor_icon;
item_margin = 15;
start_x = (room_width / 2) - (sprite_get_width(box) + item_margin);
start_y = (room_height / 4) + 100;
cursor_x = start_x;
powerup_spawn_list_x = 758 * 2;
powerup_spawn_list_y = 34;
powerup_margin = 34;
show_discard_item_prompt = false;
item_to_purchase = {};
item_to_discard = {};
item_failed_to_purchase = {};
current_item_description_box = instance_create_layer(room_width/2, room_height/6 - 40, layer, obj_tip_prompt);
purchasing_disabled = false;
randomise();

generate_inventory = function() {
    var _unlocked_powerups = get_save_data_property("powerups", global.default_unlocked_powerups);
    
    // randomly pick 3 of the unlocked powerups to appear in the shop
    FOREACH _unlocked_powerups ELEMENT
        var _powerup_is_in_spawn_list = get_powerup_from_spawn_list(_elem) != undefined;
        if (_powerup_is_in_spawn_list) {
            continue;
        }
        
        if ((random_range(0, 1) <= 0.5 && array_length(shop_items) < shop_inventory_limit) || array_length(_unlocked_powerups) <= shop_inventory_limit) {
            var _powerup_key = _elem;
            var _powerup = get_powerup_type(_powerup_key);
            var _box_x = start_x + (array_length(shop_items) * (sprite_get_width(box) + item_margin));
            var _box_y = start_y + 75;
            var _shop_item_box = instance_create_layer(_box_x, _box_y, layer, obj_shop_item);
            _shop_item_box.item = _powerup;
            array_push(shop_items, _powerup);
            array_push(shop_item_instances, _shop_item_box);
        }
    END
}

fail_purchase = function(_item) {
    item_failed_to_purchase = _item;
    with(obj_shop_item) {
        if (self.item && self.item.key == _item.key) {
            self.failed_purhase_animation();
        }
    }
}

purchase_item = function(_item) {
    var _price = _item.price;
    
    // if we already have this item, we cannot purchase two of it; also check if we can't afford it
    if (get_powerup_from_spawn_list(_item.key) != undefined || score < _price) {
        fail_purchase(_item);
        return;
    }
    
    // check if we can afford the item
    if (score >= _price) {
        // check if we have room for the item
        if (array_length(global.powerups_spawn_list) >= global.max_powerups_list_size) {
            // if no, then show the "discard item" prompt, cache item to purchase
            show_discard_item_prompt = true;
            item_to_purchase = _item;
            return;
        }
        
        // otherwise, purchase item
        add_powerup_to_spawn_list(_item.key);
        score -= _price;
        
        // remove item from shop inventory
        remove_item_from_shop(_item.key);
        
        // play animation and sound feedback
        with(obj_shop_item) {
            if (self.item && self.item.key == _item.key) {
                self.successful_purchase_animation();
            }
        }
        
        // disable purchasing to allow animations to finish
        purchasing_disabled = true;
        alarm_set(0, 60);
    }
}

remove_item_from_spawn_list = function(_item_key = "") {
    remove_powerup_from_spawn_list(_item_key);
}

remove_item_from_shop = function(_item_key = "") {

    var _item_index = 0;
    FOREACH shop_items ELEMENT
        if (_item_key == _elem.key) {
            _item_index = _i;
        }
    END
    array_delete(shop_items, _item_index, 1);
    
}

move_cursor = function(menu_list = []) {
    if (array_length(menu_list) <= 0) {
        return undefined;
    }
    
    if (input_check_pressed("right")) {
        cursor += 1;
        play_sound(snd_button_click);
    }
  
    if (input_check_pressed("left")) {
        cursor -= 1;
        play_sound(snd_button_click);
    }
    
    cursor = loop_clamp(cursor, 0, array_length(menu_list) - 1);
    
    return menu_list[cursor];
}

generate_inventory();