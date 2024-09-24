var _lay_id = layer_get_id("Background");
var _back_id = layer_background_get_id(_lay_id);
var _next_color = merge_color(layer_background_get_blend(_back_id), colors[color_index], 0.1);
// layer_background_blend(_back_id, _next_color);