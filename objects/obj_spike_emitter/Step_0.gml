spike_spawn_timer--;
spike_spawn_timer = clamp(spike_spawn_timer, 0, max_spike_spawn_timer);

if (spike_spawn_timer <= 0 && spike_count > 0) {
    spawn_spikes();
    spike_spawn_timer = max_spike_spawn_timer;
}

if (spike_count <= 0) {
    instance_destroy(self);
}