play_sound(snd_bounce, false);

other.hit = true;
other.hit_timer = other.base_stun_time;

if (global.settings.invincible_mode_enabled) {
	return;
}


// lose_life();