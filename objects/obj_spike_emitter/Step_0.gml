spike_interval--;
spike_interval = clamp(spike_interval, 0, 10);

if (spike_interval <= 0 && spike_count > 0) {
    spawn_spikes();
    spike_interval = 10;
}

if (spike_count<=0) {
    instance_destroy(self);
}