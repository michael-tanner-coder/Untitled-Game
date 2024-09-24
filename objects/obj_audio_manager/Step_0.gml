// maintain sound registry to track duplicate sounds being played
clean_sound_registry();

// check when stingers finish so that we can resume the background music
if (VinylIsPlaying(global.current_stinger)) {
    stinger_started = true;
}

if (stinger_started) {
    show_debug_message("Stinger started")
}

if (stinger_started && !VinylIsPlaying(global.current_stinger)) {
    show_debug_message("Resuming tracks");
    resume_layered_track(global.current_track_layers);
}

VinylMasterSetGain(global.settings.audio_master);


