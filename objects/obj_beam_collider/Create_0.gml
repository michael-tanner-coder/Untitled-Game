sibling_beam = undefined;
orientation = ORIENTATIONS.HORIZONTAL; 
warp_force = 8;
sequence = undefined;

spawn_beam_sequence = function() {
	
	sequence = layer_sequence_create("UI_Sequences", x, y, orientation == ORIENTATIONS.HORIZONTAL ? seq_beam_flicker : seq_beam_flicker_vertical);
	
	var _width = sprite_get_width(sprite_index);
	var _height = sprite_get_height(sprite_index);
	
	var _beam_width = orientation == ORIENTATIONS.HORIZONTAL ? sprite_get_width(spr_beam_outer) :  sprite_get_height(spr_beam_outer);
	var _beam_height = orientation == ORIENTATIONS.HORIZONTAL ? sprite_get_height(spr_beam_outer) :  sprite_get_width(spr_beam_outer);
	
	var _desired_width = _width * image_xscale;
	var _desired_height = _height * image_yscale;
	
	var _target_xscale = _desired_width / _beam_width;
	var _target_yscale = _desired_height / _beam_height;
	
	layer_sequence_xscale(sequence, _target_xscale);
	layer_sequence_yscale(sequence, _target_yscale);
	
}

subscribe(id, "end_level", function(_level_state) {
	if (_level_state == "win") {
		layer_sequence_destroy(sequence);
		spawn_beam_particles(x, y);
		instance_destroy(self);
	}
});