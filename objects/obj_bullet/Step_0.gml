leave_trail();

// Collision
if (position_meeting(x, y, obj_wall)) {
	instance_create_layer(x,y,layer,obj_impact);
	instance_destroy(self);
}