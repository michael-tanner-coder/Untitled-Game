// Base Textbox Properties
padding_x = 30;
padding_y = 10;
text_content = "template text";
typist = scribble_typist();
typist.in(0.5, 0);
typist.sound_per_char([snd_speak_med_7], 0.75, 1.25);
textbox_width = sprite_get_width(sprite_index) - (padding_x * 2);
speaker = undefined;
pages = [];
page_number = 0;
page_started = true;
page_finished = false;