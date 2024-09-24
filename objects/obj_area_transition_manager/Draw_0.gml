// CONTROLS PROMPT
// Purchase
var _select_input_sprite = input_verb_get_icon("select");
        
// Text renderer
var _text_renderer = scribble("CONTINUE: [" + sprite_get_name(_select_input_sprite) +"]");
_text_renderer.starting_format("fnt_cutscene_default", WHITE).align(fa_center, fa_middle).draw(room_width/2, room_height - 200);
