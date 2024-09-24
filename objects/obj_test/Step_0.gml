var _inputs = global.input_system.check(global.current_input_device);

if (_inputs.left.down) {
	x -= 2;
}

if (_inputs.right.down) {
	x += 2;
}