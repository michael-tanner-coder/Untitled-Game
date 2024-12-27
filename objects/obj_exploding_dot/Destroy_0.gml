standard_enemy_destroy_event();

// Explosion Logic
if (!hit) {
	instance_create_layer(x, y, layer, obj_spike_emitter);
}