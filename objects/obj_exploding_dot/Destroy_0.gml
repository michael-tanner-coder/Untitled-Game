standard_enemy_destroy_event();

// Explosion Logic
var _first_beam = instance_create_layer(x, y, layer, obj_laser);
var _second_beam = instance_create_layer(x, y, layer, obj_laser);
_first_beam.phy_rotation = phy_rotation;
_second_beam.phy_rotation = phy_rotation + 90;