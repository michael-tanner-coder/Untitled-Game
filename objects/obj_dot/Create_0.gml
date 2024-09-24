xspd = 0;
yspd = 0;
base_speed = 5;
hit = false;
hit_timer = 0;
max_dash_timer = 120;
dash_timer = 0;
point_value = 100;
x_force = 0;
y_force = 0;
shield_sprite = spr_shield;

var _shadow = instance_create_layer(x,y,layer,obj_shadow);
_shadow.depth = depth + 1;
_shadow.owner = self;