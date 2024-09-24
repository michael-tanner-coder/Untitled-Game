global.current_track_layers = [];
global.current_stinger = snd_stinger_victory;
global.sound_registry = {
	// snd_my_sound: [],
};
global.muted = false;

// MUSIC TRACK SCRIPTS

// Getter functions
function get_track_layer(_index = 0) {
	if (array_length(global.current_track_layers) <= 0) {
		return undefined;
	}
	
	if (is_array(global.current_track_layers) && array_length(global.current_track_layers) - 1 >= _index) {
		return global.current_track_layers[_index];
	} 
	
	return undefined;
}

function get_bottom_track_layer() {
	return get_track_layer(0);
}

function get_top_track_layer() {
	return get_track_layer(array_length(global.current_track_layers) - 1);
}

// Mute/Volume functions
function mute_layer(_layer, _fade_out_rate = 0) {
	
	if (_layer == undefined) {
		show_debug_message("Error: provided track layer is undefined");
		return;
	}
	
	VinylSetGain(_layer, 0, _fade_out_rate);
	
}

function unmute_layer(_layer, _gain, _fade_in_rate = 0) {
	
	if (_layer == undefined) {
		show_debug_message("Error: provided track layer is undefined");
		return;
	}
	
	VinylSetGain(_layer, _gain, _fade_in_rate);
	
}

// Playback functions
function stop_all_tracks() {
	FOREACH global.current_track_layers ELEMENT
		VinylStop(_elem);
	END
	
	global.current_track_layers = [];
}

function pause_all_tracks() {
	FOREACH global.current_track_layers ELEMENT
		pause_track(_elem);
	END
}

function play_track(_track = 0, _stop_previous_tracks = true) {
	if (global.muted) {
		return;
	}
	
	if (_stop_previous_tracks) {
		stop_all_tracks();
		stop_current_stinger();
	}
	
	var _track_voice = play_sound(_track, true);
	
	array_push(global.current_track_layers, _track_voice);
}

function play_layered_track(_layers = [], _stop_previous_tracks = true) {
	if (_stop_previous_tracks) {
		stop_all_tracks();
		stop_current_stinger();
	}
	
	FOREACH _layers ELEMENT
		play_track(_elem, false);
	END
} 

function pause_track(_track) {
	VinylSetPause(_track, true);
}

function pause_layered_track(_layers = []) {
	FOREACH _layers ELEMENT
		VinylSetPause(_elem, true);
	END
}

function resume_track(_track) {
	VinylSetPause(_track, false);
}

function resume_layered_track(_layers = []) {
	FOREACH _layers ELEMENT
		resume_track(_elem);
	END
}

// STINGERS
function stop_current_stinger() {
	VinylStop(global.current_stinger);
}

function play_stinger(_track = 0) {
	pause_all_tracks();
	stop_current_stinger();
	global.current_stinger = play_sound(_track, false);
	return global.current_stinger							// return the stinger if we need to check when it finishes playing
}

// SOUND PRIORITY/MIXING
enum AUDIO_GROUP {
	AMBIENT = 1,
	MUSIC = 2,
	UI = 3,
	FEEDBACK = 4,
	DANGER = 5,
}

global.audio_group_priority_struct = {
	danger: AUDIO_GROUP.DANGER,
	feedback: AUDIO_GROUP.FEEDBACK,
	UI: AUDIO_GROUP.UI,
	music: AUDIO_GROUP.MUSIC,
	ambient: AUDIO_GROUP.AMBIENT,
}

function play_sound(_sound, _loop = false, _pitch = 1) {
	
	// get the priority of the sound based on its audio group
	var _group_name = audio_group_name(audio_sound_get_audio_group(_sound));
	var _sound_name = audio_get_name(_sound);
	var _priority = global.audio_group_priority_struct[$ _group_name];
	
	// prevent overlapping sounds of the same asset at the same time
	var _voices_array = struct_get(global.sound_registry, _sound_name);
	if (is_array(_voices_array) && array_length(_voices_array) > 0) {
		FOREACH _voices_array ELEMENT
			var _current_voice = _elem;
			var _audio_length = audio_sound_length(_sound);
			var _audio_position = audio_sound_get_track_position(_current_voice);
			var _audio_completion_percentage = _audio_position / _audio_length;
			if (audio_is_playing(_sound) && _audio_completion_percentage < DUPLICATE_SOUND_TOLERANCE) {
				return undefined;	
			}
		END
	}
	
	// play sound if priority is found
	if (_priority) {
		var _voice = VinylPlay(_sound, _loop, 1, _pitch);
		
		// register sound name and voice
		if (!is_array(struct_get(global.sound_registry, _sound_name))) {
			global.sound_registry[$ _sound_name] = [_voice];
		}
		else {
			array_push(global.sound_registry[$ _sound_name], _voice);
		}
		
		// return voice for external use
		return _voice;
	}
	
	// don't return a sound asset if nothing is played
	return undefined;
	
}

function clean_sound_registry() {

	// check sound registry for playing sounds; remove sounds that are done or about to finish
	var _sound_registry_keys = struct_get_names(global.sound_registry);
	FOREACH _sound_registry_keys ELEMENT
	    var _key = _elem;
	    var _voices = struct_get(global.sound_registry, _key);
	    var _deletionIndex = 0;
	    var _deleteIndex = false;
	    
	    for (var _j = 0; _j <= array_length(_voices) - 1; _j++) {
	        var _current_voice = _voices[_j];
	        if (VinylWillStop(_current_voice) || !VinylIsPlaying(_current_voice)) {
	            _deletionIndex = _j;
	            _deleteIndex = true;
	        }
	    }
	    
	    if (_deleteIndex) {
	        array_delete(_voices, _deletionIndex, 1);
	        global.sound_registry[$ _key] = _voices;
	    }
	END
	
}




