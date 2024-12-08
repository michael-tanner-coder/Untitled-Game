global.currency += 500;
var _score_text = instance_create_layer(x,y,layer, obj_float_text);
_score_text.text = "+" + string(500);
_score_text.text_sprite = spr_mana_icon;
draw_set_font(_score_text.text_font);
_score_text.text_sprite_offset_x = (-1 * string_width(_score_text.text)/2)-4;
play_sound(snd_points, false);
instance_destroy(other);