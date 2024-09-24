top_limit = y - (sprite_height/2) + (image_xscale*75);
bottom_limit = y + (sprite_height/2) - (image_xscale*75);

slider = instance_create_layer(x,y,layer,obj_slider);
slider.image_xscale = image_xscale;
slider.image_yscale = image_yscale;
slider.bar_length = sprite_height;
slider.top_limit = top_limit;
slider.bottom_limit = bottom_limit;
slider.y = top_limit;
slider.depth = depth -1;
