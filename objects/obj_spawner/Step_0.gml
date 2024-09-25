// dont' spawn while still in the tutorial phase
if (global.tutorial) {
	return;
}

if (fsm.event_exists("step")) {
	fsm.step();
}