global.currency += 500;
var _score_text = instance_create_layer(x,y,layer, obj_float_text);
_score_text.text = "+$" + string(500);
play_sound(snd_points, false);
instance_destroy(other);