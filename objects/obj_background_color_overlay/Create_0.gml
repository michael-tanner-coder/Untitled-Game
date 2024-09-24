image_alpha = 0.6;
image_blend = PINK;

var _scene = get_current_scene();
var _bg_color = struct_get(_scene, "bg_color");
if (_bg_color != undefined) {
    image_blend = _bg_color;
}