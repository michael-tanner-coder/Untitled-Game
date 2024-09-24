// Progress to next line of diaglogue
if (input_check_pressed("progress")) {
    if (typist.get_state() == 1) {
    	page_number += 1;
    	page_started = true;
    }
    else {
    	typist.skip();
    }
    
    play_sound(snd_button_back_alt, false);
}