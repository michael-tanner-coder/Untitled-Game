image_xscale = lerp(image_xscale, 1, 0.04);
image_yscale = lerp(image_yscale, 1, 0.04);
image_alpha -= 0.01;
if (image_alpha <= 0) {
	instance_destroy(self);
}
