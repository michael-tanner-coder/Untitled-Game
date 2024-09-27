if (highlighted) {
	y = lerp(y, target_y, 0.08);
}
else {
	y = lerp(y, original_y, 0.08);
}

if (highlighted && mouse_check_button_pressed(mb_left)) {
	publish(UPGRADE_SELECTED, upgrade);
}