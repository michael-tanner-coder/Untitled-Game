if (global.settings.invincible_mode_enabled || other.boss_defeated) {
	return;
}

other.lose_life();