xspd = 0;
yspd = 0;
base_speed = 10;
hit = false;
hit_timer = 0;
point_value = 400;
x_force = 0;
y_force = 0;
shield_sprite = spr_shield_big;

var _shadow = instance_create_layer(x,y,layer,obj_shadow);
_shadow.depth = depth + 1;
_shadow.owner = self;
_shadow.sprite_index = spr_shadow_big;