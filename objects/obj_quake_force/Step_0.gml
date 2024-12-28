image_xscale = get_animation_value("scale");
image_yscale = get_animation_value("scale");
image_alpha = 1 - get_animation_value("alpha");
progress_animation();

if (image_alpha <= 0) {
	instance_destroy(self);
}