function draw_text_outlined_ext(_x = 0, _y = 0, _outline_color = c_white, _color = c_black, _string = "", _outline_thickness = 1, _x_scale = 1, _y_scale = 1) {
	///@arg x
	///@arg y
	///@arg outlinecolor
	///@arg string_color
	///@arg string
	///@arg outline_thickness
	///@arg xscale 
	///@arg yscale 

	var xx,yy;  
	xx = _x;  
	yy = _y;
	var _thickness = _outline_thickness;
  
	//Outline  
	draw_set_color(_outline_color);  
	draw_text_transformed(xx + _thickness,	yy + _thickness, _string, _x_scale, _y_scale, 0);
	draw_text_transformed(xx - _thickness,	yy - _thickness, _string, _x_scale, _y_scale, 0);
	draw_text_transformed(xx,				yy + _thickness, _string, _x_scale, _y_scale, 0);
	draw_text_transformed(xx + _thickness,  yy,				 _string, _x_scale, _y_scale, 0); 
	draw_text_transformed(xx,				yy - _thickness, _string, _x_scale, _y_scale, 0);
	draw_text_transformed(xx - _thickness,	yy,				 _string, _x_scale, _y_scale, 0);
	draw_text_transformed(xx - _thickness,	yy + _thickness, _string, _x_scale, _y_scale, 0);
	draw_text_transformed(xx + _thickness,	yy - _thickness, _string, _x_scale, _y_scale, 0);

	//Text  
	draw_set_color(_color);  
	draw_text_transformed(xx, yy, argument[4], _x_scale, _y_scale, 0);
	draw_set_color(c_white); 

}

function draw_outlined_text(text_x, text_y, text_string, text_color, font, outline_distance, outline_color) {
	// ---- white text pass
	font_enable_effects(font, true, {
		outlineEnable: true,
		outlineDistance: outline_distance,
		outlineColour: outline_color,
	});
	draw_set_color(outline_color);
	draw_text(text_x, text_y, text_string);
	
	// // ---- color text pass
	font_enable_effects(font, true, {
		outlineEnable: false,
		outlineDistance: 0,
	});
	draw_set_color(text_color);
	draw_set_font(font);
	draw_text(text_x, text_y, text_string);
}

function parse_scribble_events(_text) {
	
	var _event_started = false;
	var _event_string = "";
	var _string_array = [];
	var _event_array = [];
	
	for(var _i = 1; _i < string_length(_text); _i++) {
		var _current_char = string_char_at(_text, _i);
		array_push(_string_array, _current_char);
	}
	
	FOREACH _string_array ELEMENT
		if (!_event_started && _elem == "[") {
			_event_started = true;
		}
		
		if (_event_started) {
			_event_string = string_concat(_event_string, _elem);
		}
		
		if (_event_started && _elem == "]") {
			_event_started = false;
			_event_string = string_concat(_event_string, "|");
		}
	END
	
	_event_string = string_delete(_event_string, string_length(_event_string), 1);
	var _delimited_events = string_split(_event_string, "|");
	
	FOREACH _delimited_events ELEMENT
		_elem = string_delete(_elem, 0, 1);
		_elem = string_delete(_elem, string_length(_elem), 1);
		var _elem_array = string_split(_elem, " ");
		array_push(_event_array, _elem_array);
	END
		
	show_debug_message(_event_array);
	
	return _event_array;
	
}
