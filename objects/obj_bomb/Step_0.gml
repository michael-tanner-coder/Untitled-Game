time_until_explosion--;

if (time_until_explosion <= 0 ) {
	instance_create_layer(x, y, layer, obj_quake_force);
	instance_destroy(self);
}