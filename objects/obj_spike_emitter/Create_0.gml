spike_sets = [[1,0], [0, 1], [-1, 0], [0, -1]];
spike_count = 5;
spike_interval = 20;
spike_separation_degrees = 90;
starting_angle = 0;

spawn_spikes = function() {
    var _direction = starting_angle;
    
    for(var _i = 0; _i < array_length(spike_sets); _i++) {
        var _current_set = spike_sets[_i];
        var _spike = instance_create_layer(x, y, layer, obj_spike);
        
        _spike.x += sprite_get_width(_spike.sprite_index) * _current_set[0];
        _spike.y += sprite_get_width(_spike.sprite_index) * _current_set[1];

        _spike.x_speed = lengthdir_x(_spike.speed, _direction);
        _spike.y_speed = lengthdir_y(_spike.speed, _direction);

        with (_spike) {
            direction = _direction;
            image_angle = _direction;
        }
        
        _direction -= spike_separation_degrees;
    }
    
    spike_count--;
}

instance_create_layer(x, y, layer, obj_quake_force);