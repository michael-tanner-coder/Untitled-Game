standard_enemy_destroy_event();

// Explosion Logic
if (!hit) {
	screenshake(1, 6, 0.5);
	instance_create_layer(x, y, layer, obj_spike_emitter);
}