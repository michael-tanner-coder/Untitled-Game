input_id = "";

// String Properties
input_string = "";
input_string_x = x;
input_string_y = y;
keyboard_string = input_string;
input_character_limit = 10;

// Style Properties
font = fnt_default;
text_color = WHITE;
text_shadow_color = PURPLE;

// Scribble effects
typist = scribble_typist();
typist.in(4, 100);
typist.sound_per_char([snd_speak_med_7], 0.75, 1.25);
typist.ease(SCRIBBLE_EASE.ELASTIC, 0, 4, 1, 1, 0, 0);

// Cursor
cursor_width = 4;
max_flicker_time = 20;
flicker_time = max_flicker_time;

// State
disabled = false;
focused = true;