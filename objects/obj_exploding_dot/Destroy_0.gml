standard_enemy_destroy_event();

// Explosion only when at full size
if (!hit) {
	screenshake(1, 6, 0.5);
}

// Spike Emitter
emitted_spikes = ceil(max_spikes * (image_xscale/max_scale));
var _spike_emitter = instance_create_layer(x, y, layer, obj_spike_emitter);
_spike_emitter.spike_count = emitted_spikes;