
function spawn_dust_particles() {
	
	// if (!global.settings.particles) {
	// 	return;
	// }
	
	var _emitter = instance_create_layer(x, y, layer, obj_particle_emitter);
	part_particles_create(_emitter.particle_system, x, y + sprite_height/2, _emitter.dust_particles, 1);
	instance_destroy(_emitter);
	
}

function spawn_puff_particles(){
	
	// if (!global.settings.particles) {
	// 	return;
	// }
	
	var _emitter = instance_create_layer(x + sprite_width / 2, y + sprite_height / 2,layer, obj_particle_emitter);
	part_particles_create(_emitter.particle_system, x + sprite_width / 2, y+sprite_height / 2, _emitter.puff_particles, 16);
	instance_destroy(_emitter);

}

function spawn_sparkles(_particle_x = 0,_particle_y = 0){
	
	// if (!global.settings.particles) {
	// 	return;
	// }
	
	// var _emitter = instance_create_layer(x, y, layer, obj_particle_emitter);
	// if (_emitter != undefined && _emitter != noone) {
	// 	part_particles_create(_emitter.particle_system, _particle_x, _particle_y, _emitter.spark_particles, 5);
	// 	instance_destroy(_emitter);
	// }
	
	// var _sys = part_system_create();
	// part_particles_burst(_sys, _particle_x, _particle_y, sparkles);
	layer_sequence_create(layer, _particle_x, _particle_y, seq_key_collect);
	
}

function spawn_beam_particles(_particle_x = 0,_particle_y = 0){
	
	// if (!global.settings.particles) {
	// 	return;
	// }
	
	var _emitter = instance_create_layer(x, y, layer, obj_particle_emitter);
	if (_emitter != undefined && _emitter != noone) {
		part_particles_create(_emitter.particle_system, _particle_x, _particle_y, _emitter.beam_particles, 10);
		instance_destroy(_emitter);
	}
	
}

function spawn_trail() {
	
	var _emitter = instance_create_layer(x, y, layer, obj_particle_emitter);
	part_type_sprite(_emitter.trail_particles, sprite_index, 0, 0, 1);
	part_particles_create(_emitter.particle_system, x, y, _emitter.trail_particles, 1);
	instance_destroy(_emitter);
	
}

function spawn_inward_particles(_spawn_x, _spawn_y) {

	var _dir = random(360);
    var _dist = 100;
    var _x = _spawn_x + lengthdir_x(_dist, _dir);
    var _y = _spawn_y + lengthdir_y(_dist, _dir);
    var _part_dir = point_direction(_x, _y, _spawn_x, _spawn_y);
	var _emitter = instance_create_layer(_x, _y, layer, obj_particle_emitter);
    part_type_direction(_emitter.inward_particles, _part_dir, _part_dir, 0, 0);
	part_particles_create(_emitter.particle_system, _x, _y, _emitter.inward_particles, 1);

}

function spawn_block_destruction_particles(_x, _y) {
	var _sys = part_system_create();
	part_particles_burst(_sys, _x, _y, block_destruction);
}

function spawn_enemy_key_sparkles(_x, _y) {
	var _sys = part_system_create();
	part_particles_burst(_sys, _x, _y, sparkles);
}

function spawn_enemy_destruction_particles(_x, _y) {
	var _sys = part_system_create();
	part_particles_burst(_sys, _x, _y, enemy_destruction);
}