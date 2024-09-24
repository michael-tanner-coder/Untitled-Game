// Scaling
var _item_box_xscale = 0.5;
var _item_box_yscale = 0.5;

// Sprite Drawing
draw_sprite(item.sprite, 0, x, y);

if (!failed_purchase && !successful_purchase) {
    draw_sprite_ext(sprite_index, 0, x, y, _item_box_xscale, _item_box_yscale, 0, WHITE, 1);
}