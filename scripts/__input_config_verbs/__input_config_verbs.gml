// Feather disable all

//This script contains the default profiles, and hence the default bindings and verbs, for your game
//
//  Please edit this macro to meet the needs of your game!
//
//The struct return by this script contains the names of each default profile.
//Default profiles then contain the names of verbs. Each verb should be given a binding that is
//appropriate for the profile. You can create bindings by calling one of the input_binding_*()
//functions, such as input_binding_key() for keyboard keys and input_binding_mouse() for
//mouse buttons

function __input_config_verbs()
{
    return {
        keyboard_and_mouse:
        {
            // character actions
            up:    [input_binding_key(vk_up),    input_binding_key("W")],
            down:  [input_binding_key(vk_down),  input_binding_key("S")],
            left:  [input_binding_key(vk_left),  input_binding_key("A")],
            right: [input_binding_key(vk_right), input_binding_key("D")],
            jump: input_binding_key(vk_space),
            
            // UI actions
            accept:  input_binding_key(vk_space),
            select: [input_binding_key(vk_space), input_binding_key(vk_enter)],
            cancel:  [input_binding_key("X"), input_binding_key(vk_backspace)],
            action:  input_binding_key(vk_enter),
            special: input_binding_key(vk_shift),
            progress: input_binding_key(vk_space),
            skip: [input_binding_key("X"), input_binding_key(vk_enter)],
            quit: input_binding_key("X"),
            pause: input_binding_key(vk_escape),
            
            // Dev tools
            next_scene: [input_binding_key("D")],
            prev_scene: [input_binding_key("A")],
            switch_character: [input_binding_key("S")],
            
        },
        
        gamepad:
        {
            // character
            up:    [input_binding_gamepad_axis(gp_axislv, true),  input_binding_gamepad_button(gp_padu)],
            down:  [input_binding_gamepad_axis(gp_axislv, false), input_binding_gamepad_button(gp_padd)],
            left:  [input_binding_gamepad_axis(gp_axislh, true),  input_binding_gamepad_button(gp_padl)],
            right: [input_binding_gamepad_axis(gp_axislh, false), input_binding_gamepad_button(gp_padr)],
            jump: input_binding_gamepad_button(gp_a),
            
            // UI
            accept:  input_binding_gamepad_button(gp_face1),
            cancel:  input_binding_gamepad_button(gp_face2),
            action:  input_binding_gamepad_button(gp_face3),
            special: input_binding_gamepad_button(gp_face4),
            skip: input_binding_gamepad_button(gp_start),
            progress: input_binding_gamepad_button(gp_a),
            select: input_binding_gamepad_button(gp_a),
            quit: input_binding_gamepad_button(gp_select),
            pause: input_binding_gamepad_button(gp_start),
        },
        
        touch:
        {
            up:    input_binding_virtual_button(),
            down:  input_binding_virtual_button(),
            left:  input_binding_virtual_button(),
            right: input_binding_virtual_button(),
            
            accept:  input_binding_virtual_button(),
            cancel:  input_binding_virtual_button(),
            action:  input_binding_virtual_button(),
            special: input_binding_virtual_button(),
            
            pause: input_binding_virtual_button(),
        }
    };
}