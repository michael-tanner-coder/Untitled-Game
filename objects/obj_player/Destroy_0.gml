lives = 0;
var _sys = part_system_create();
part_particles_burst(_sys, x, y, part_death);
audio_play_sound(snd_die, 1, false);
screenshake(1, 6, 0.5);