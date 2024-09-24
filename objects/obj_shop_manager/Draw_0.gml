// SHOP CURSOR POSITION
if (!show_discard_item_prompt) {
    FOREACH shop_item_instances ELEMENT
        var _x = start_x + (_i * (sprite_get_width(box) + item_margin));
        var _y = start_y;
        var _item_box_xscale = 0.5;
        var _item_box_yscale = 0.5;
        if (_i == cursor) {
            cursor_x = lerp(cursor_x, _elem.x, cursor_movement_rate);
            draw_sprite(cursor_icon, 0, cursor_x, _y - ((sprite_get_height(box) / 2) * _item_box_xscale));    
        }
    END
}

// DISCARD ITEM PROMPT
if (show_discard_item_prompt) {
    // Underlay
    draw_set_alpha(0.8);
    draw_set_color(BLACK);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);
    
    // Prompt text
    draw_set_color(WHITE);
    draw_text(start_x, start_y - 80, "PICK ONE TO DISCARD");
    
    // Current powerups
    FOREACH global.powerups_spawn_list ELEMENT
        var _x = start_x + (_i * (sprite_get_width(box) + item_margin));
        var _y = start_y + room_height/2;
        draw_sprite_ext(box, 0, _x, _y, 0.5, 0.5, 0, c_white, 1);
        draw_sprite(_elem.sprite, 0, _x, _y);
        if (_i == cursor) {
            cursor_x = lerp(cursor_x, _x, cursor_movement_rate);
            draw_sprite(cursor_icon, 0, cursor_x, _y - (sprite_get_height(box) / 2));    
        }
    END
}

// CONTROLS PROMPT
// Purchase
var _select_input_sprite = input_verb_get_icon("select");
        
// Cancel
var _cancel_input_sprite = input_verb_get_icon("cancel");

// Text renderer
var _text_renderer = scribble("PURCHASE: [" + sprite_get_name(_select_input_sprite) +"]\nCANCEL/EXIT: [" + sprite_get_name(_cancel_input_sprite) +"]");
_text_renderer.starting_format("fnt_cutscene_default", WHITE).align(fa_center, fa_middle).draw(room_width/2, room_height - 200);
