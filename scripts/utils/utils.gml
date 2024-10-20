function draw_8_direction_movement(sprite_sheet, frame_w, frame_h, animation_length, alpha = 1, color = c_white, x_offset = 0, y_offset = 0) {
	// get animation direction
	var _movement_direction = -point_direction(0, 0, phy_speed_x, phy_speed_y);
	y_frame = (_movement_direction / 45) * -1;
	x_frame += anim_speed / room_speed;
	x_frame = loop_clamp(x_frame, 0, animation_length);
	
	// halt animation when physics speed is zero
	anim_speed = floor(phy_speed) * base_anim_speed;
	
	// draw piece of sprite sheet
	draw_sprite_part_ext(
		sprite_sheet,
		0,
		floor(x_frame) * frame_w,
		floor(y_frame) * frame_h,
		frame_w,
		frame_h,
		floor(x - x_offset),
		floor(y - y_offset),
		image_xscale,
		image_yscale, 
		color,
		alpha,
	);
}

function leave_trail(_color = c_white) {
	/*if (x_force == 0 && y_force == 0) {
		return;
	}*/
	
	with (instance_create_depth(x, y, depth+1, obj_trail)) {
		/*var _other_width = sprite_get_width(other.sprite_index);
		var _other_height = sprite_get_height(other.sprite_index);
		
		var _trail_width = sprite_get_width(spr_trail);
		var _trail_height =  sprite_get_height(spr_trail);
		
		var _desired_width = 32;
		var _desired_height = 32;
		
		var _target_xscale = _desired_width / _trail_width;
		var _target_yscale = _desired_height / _trail_height;*/
		
		//image_xscale =_target_xscale;
		//image_yscale =_target_yscale;
		sprite_index = other.sprite_index;
		image_blend = _color;
		image_alpha = 0.5;
		image_angle = other.image_angle;
	}
}

function draw_shadow_text(x,y,_text = "",_color = WHITE, _shadow_color=PURPLE) {
	draw_set_color(_shadow_color);
	draw_text(x + 2,y + 2,_text);
	draw_set_color(_color);
	draw_text(x,y,_text);
}

function fillbar(_x = 0, _y = 0, _width = 100, _height = 50, _fill_percentage = 1, _fill_color = RED, _outline_color = undefined) {
	var _border_size = 1;
	
	if (_outline_color != undefined) {
		draw_set_color(_outline_color);
		draw_rectangle(_x, _y, _x + _width, _y + _height, false);
	}
	
	draw_set_color(_fill_color);
	draw_rectangle(_x + _border_size, _y + _border_size, _x + (_width * _fill_percentage) - _border_size, _y + _height - (_border_size * 2), false);
}

function banner(_height = 100, _position = room_height/2, _content = "", _background_color = BLACK, _opacity = 1) {
	draw_set_alpha(_opacity);
	draw_set_color(_background_color);
	draw_rectangle(0, _position, room_width, _position + _height, false);
	draw_set_alpha(1);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_shadow_text(room_width/2, _position + _height/2, _content);
}