global.current_input_device = 0;

global.input_system = new InputSystem({
     right: [vk_right,  "d", gp_padr],
     left:  [vk_left,   "a", gp_padl],
     up:   	[vk_up,   "w", gp_padu],
     down:  [vk_down,   "s", gp_padd],
     jump:  [vk_space, gp_a],
	 pause: [vk_enter, vk_escape, gp_start],
	 skip: [vk_enter, gp_start, gp_b],
	 progress: [vk_space, gp_a],
	 select: [vk_enter, vk_space, gp_a],
	 quit: [vk_backspace],
});