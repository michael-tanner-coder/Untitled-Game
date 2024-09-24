other.touching_warp_beam = true;

if (other.warping_enabled || (other.object_index == obj_player && check_for_level_bounds(other))) {
	spawn_beam_particles(other.x, other.y);
	
	// find sibling beam
	var my_ID = id;
	var my_orientation = orientation;
	for (var _i = 0; _i < instance_number(obj_beam_collider); ++_i;)
	{
		var _beam_instance = instance_find(obj_beam_collider, _i);
		if (_beam_instance != my_ID && _beam_instance.orientation == my_orientation) {
			sibling_beam = _beam_instance;
		}
	}
	
	// warp to sibling beam coordinates
	var _warp_x = sibling_beam.x;
	var  _warp_y = sibling_beam.y;
	
	if (orientation == ORIENTATIONS.HORIZONTAL) {
		other.y = _warp_y;
	}
	else if (orientation == ORIENTATIONS.VERTICAL) {
		// push the character away from the beam to prevent instant re-warping
		var _force = warp_force;
		if (other.object_index != obj_player) {
			_force = 5;
		}
		
		if (x < room_width / 2) {
			other.xforce = -1 * _force;
		}
		if (x > room_width / 2) {
			other.xforce = _force;
		}
		
		other.x = _warp_x;
	}
	
	other.iframes = other.screenwrap_iframes + other.bonus_iframes;
	other.is_screenwrapping = true;
	other.fall_speed = 0.85;
	
	spawn_beam_particles(other.x, other.y);
}
