time_until_explosion--;

if (time_until_explosion <= 120) {
	image_index = 1;
	max_beat = 10;
}

if (time_until_explosion <= 30) {
	image_index = 2;	
	max_beat = 5;
}

if (time_until_explosion <= 0 ) {
	instance_create_layer(x, y, layer, obj_quake_force);
	instance_destroy(self);
}

beat--;
if (beat < 0) {
	image_xscale = target_size * 1.2;
	image_yscale = target_size * 1.2;
	beat = max_beat;
}

image_xscale = lerp(image_xscale, target_size, 0.3);
image_yscale = lerp(image_yscale, target_size, 0.3);
