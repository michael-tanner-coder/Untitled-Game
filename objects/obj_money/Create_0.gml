// Shadow
var _shadow = instance_create_layer(x, y + sprite_get_height(sprite_index)/2, layer, obj_shadow);
_shadow.owner = self;
_shadow.offset_y = sprite_get_height(sprite_index)/2;
_shadow.follow_owner = false;
_shadow.depth = depth + 1;
_shadow.sprite_index = spr_coin_shadow;

// Animation
starting_y = y; // original y position from before we start animating
display_y = y;
target_y = y + 8; // destination y position when animating
animation_progress = 0;
animation_speed = 0.02;
animation = SineWave;
