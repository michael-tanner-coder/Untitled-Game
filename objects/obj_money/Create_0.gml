// Shadow
var _shadow = instance_create_layer(x, y, layer, obj_shadow);
_shadow.owner = self;
_shadow.depth = depth + 1;

// Animation
starting_y = y; // original y position from before we start animating
display_y = y;
target_y = y + 16; // destination y position when animating
animation_progress = 0;
animation_speed = 0.01;
animation = SineWave;
