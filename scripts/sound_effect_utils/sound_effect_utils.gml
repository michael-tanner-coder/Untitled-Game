function play_footstep(_footsteps = []) {
    var _footstep_sound = _footsteps[irandom_range(0, array_length(_footsteps) - 1)];
    play_sound(_footstep_sound, false);
}