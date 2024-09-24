// CONTROLS PROMPT
// Purchase
var _progress_input_sprite = input_verb_get_icon(progress_input_key);
var _skip_input_sprite = input_verb_get_icon(skip_input_key);
        
// Text renderer
var _text_renderer = scribble("CONTINUE: [" + sprite_get_name(_progress_input_sprite) +"]\nSKIP: [" + sprite_get_name(_skip_input_sprite) + "]");
_text_renderer.starting_format("fnt_cutscene_default", WHITE).align(fa_center, fa_middle).draw(room_width/2, room_height - 125);