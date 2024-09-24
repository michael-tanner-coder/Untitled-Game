if (global.first_wave_complete) {
	var _back_layer = layer_get_id("Background");
	var _back_layer_1 = layer_get_id("Background_1");
	layer_hspeed(_back_layer, 4);
	layer_vspeed(_back_layer, 4);
	layer_hspeed(_back_layer_1, 2);
	layer_vspeed(_back_layer_1, 2);
}

if (global.first_wave_complete && !audio_is_playing(snd_combat_music)) {
	play_track(snd_combat_music, true);
}