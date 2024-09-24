score_table_x = -1000;
score_table_y = 264;
border_x = 0;
victory = false;
game_over = false;
score_structs = [];
hold_timer = 0;
max_hold_timer = 100;

var _temp_data_source = undefined;
with(obj_game_manager) {
    _temp_data_source = self;
}
data_source = _temp_data_source;

render_level_end_scores = function(header, scores = [], row_margin) {
	
    // Score Table on Victory Screen
    // -- background underlay
    var _pillar_box_width = 32 * 13;
    var _target_score_table_x = view_xport[0] + _pillar_box_width;
    var _block_width = sprite_get_width(spr_pillar_box);
    var _game_area_width = camera_get_view_width(view_camera[0]) - _pillar_box_width * 2;
    var _block_scale_width = _game_area_width / _block_width;
    var _block_scale_height = 8;
    var _underlay_height = _block_scale_height * sprite_get_height(spr_pillar_box);
    var _outline_size = 4;
    var _character_color = c_white;
    draw_sprite_ext(spr_pillar_box, 0, score_table_x, score_table_y, _block_scale_width, _block_scale_height, image_angle, image_blend, 0.6);
    
    score_table_x = lerp(score_table_x, _target_score_table_x, 0.2);
    
    // -- character properties and color
    var _current_character = get_current_character_in_queue();
    
	if (_current_character > array_length(global.character_properties) - 1) {
	    return;
	}
	
	var _current_character_properties = global.character_properties[_current_character];
	_character_color = struct_get(_current_character_properties, "color");
	
	// -- borders
	var _rect_width = 172;
	var _rect_height = 10;
	var _rect_count = _game_area_width / _rect_width;
	var _total_border_width = _rect_width * _rect_count;
	
	for(var _i = 0; _i <= _rect_count * 2; _i++) {
		
		if (_i % 2 == 0) {
			draw_set_color(_character_color);
		} else {
			draw_set_color(c_white);
		}
		
		var _rect_x = (border_x + score_table_x + _rect_width * _i) - (_rect_width * 2);
		var _rect_y = score_table_y;
		
		draw_rectangle(_rect_x, _rect_y, _rect_x + _rect_width, _rect_y + _rect_height, false);
		draw_rectangle(_rect_x, _rect_y + _underlay_height, _rect_x + _rect_width, _rect_y + _underlay_height + _rect_height, false);
	}
	
	border_x += 1;
	if (border_x >= _rect_width * 2) {
		border_x = 0;
	}
	
	// -- victory header
	var _score_table_header = header;
	var _score_table_text_x = score_table_x + (_block_scale_width * _block_width) / 2;
	var _score_table_text_y = score_table_y + 40;
	draw_set_halign(fa_center);
	draw_outlined_text(_score_table_text_x, _score_table_text_y, _score_table_header, _character_color, fnt_header, _outline_size, c_white);

	// -- base points
	var _text_x_padding = 30;
	var _text_y_padding = 120;
	var _text_y_margin = row_margin;
	var _text_size = font_get_size(fnt_paragraph);
	
	var _labels_column_start_x = score_table_x + 20;
	var _labels_column_start_y = score_table_y + _text_y_padding;
	
	var _points_column_start_x = score_table_x + (_block_scale_width * _block_width) - _text_x_padding;
	var _points_column_start_y = _labels_column_start_y;
	
	var _tally_column_start_x = score_table_x + 660;
	var _tally_column_start_y = _labels_column_start_y;
	
	var _score_font = fnt_paragraph;
	
	draw_set_font(_score_font);
	
	// iterate over score structs and move them one at a time
	FOREACH score_structs ELEMENT
	    var _current_score = _elem;
	    
	    if (_current_score.current_x == -1000) {
	    	play_sound(snd_time_counter, false);
	    }
	    
	    if (_current_score.label == "TOTAL SCORE") {
	    	_current_score.points = score;
	    }
		
		var _current_score_y = _labels_column_start_y + ((_text_size + _text_y_margin) * _i);
		_current_score.current_x = lerp(_current_score.current_x, 0, 0.4);
		_current_score.current_points = lerp(_current_score.current_points, _current_score.points, 0.3);
		var _rounded_score = round(_current_score.current_points);
		
		// label
		draw_set_halign(fa_left);
		draw_set_color(_character_color);
		draw_outlined_text(_labels_column_start_x + _current_score.current_x, _current_score_y, _current_score.label, _character_color, _score_font, 4, c_white);
		
		// tally
		if (_current_score.tally != undefined) {
			draw_set_halign(fa_center);
			draw_set_color(c_white);
			draw_text(_tally_column_start_x + _current_score.current_x, _current_score_y, string(_current_score.tally));
		}
	
		// points
		draw_set_halign(fa_right);
		draw_set_color(c_white);
		draw_text(_points_column_start_x + _current_score.current_x, _current_score_y, _rounded_score);
		
		// don't start moving any other rows until we finish moving this one 
		if (_current_score.current_x != 0 || _current_score.current_points != _current_score.points) {
			break;
		}
	END
	
}

render_skip_inputs = function() {
	
	// -- character properties and color
    var _current_character = get_current_character_in_queue();
	if (_current_character > array_length(global.character_properties) - 1) {
	    return;
	}
	
	var _current_character_properties = global.character_properties[_current_character];
	_character_color = struct_get(_current_character_properties, "color");
	
	// --- "Press to Skip" prompt ---
	// prompt box
	var _skip_prompt_width = 318;
	var _skip_prompt_height = 74;
	var _skip_prompt_x = 1125;
	var _skip_prompt_y = 200;
	draw_set_color($2C1E19);
	draw_set_alpha(0.6);
	draw_roundrect_ext(_skip_prompt_x, _skip_prompt_y, _skip_prompt_x + _skip_prompt_width, _skip_prompt_y + _skip_prompt_height, 16, 16, false);
	draw_set_alpha(1);
	
	// prompt label
	draw_set_color(c_white);
	draw_set_halign(fa_center);
	draw_set_font(fnt_paragraph);
	var _prompt_height = string_height("SPACE: SKIP");
	draw_text(_skip_prompt_x + _skip_prompt_width / 2, _skip_prompt_y, "SPACE: SKIP");
	
	// --- "Hold to Continue" prompt ---
	// prompt box
	var _pillar_box_width = 32 * 13;
    var _target_score_table_x = view_xport[0] + _pillar_box_width;
    var _block_width = sprite_get_width(spr_pillar_box);
    var _game_area_width = camera_get_view_width(view_camera[0]) - _pillar_box_width * 2;
    var _block_scale_width = _game_area_width / _block_width;
    var _block_scale_height = 2;
    var _underlay_height = _block_scale_height * sprite_get_height(spr_pillar_box);
    var _outline_size = 4;
	var _continue_prompt_y = 830;
	var _continue_prompt_x = 416;
	draw_sprite_ext(spr_pillar_box, 0, _continue_prompt_x, _continue_prompt_y, _block_scale_width, _block_scale_height, image_angle, image_blend, 0.6);

	// prompt label
	var _prompt_margin_y = 12;
	draw_set_color(c_white);
	draw_set_halign(fa_center);
	draw_set_font(fnt_header);
	draw_text(_continue_prompt_x + (_block_width * _block_scale_width) / 2, (_continue_prompt_y + _underlay_height / 8) - _prompt_margin_y, "HOLD ENTER TO CONTINUE");
	
	// meter outline
	var _rect_width = 226;
	var _rect_height = 34;
	var _rect_x = (_continue_prompt_x + (_block_width * _block_scale_width) / 2) - _rect_width/2;
	var _rect_y = (_continue_prompt_y + _underlay_height / 2) + 15;
	draw_roundrect_ext(_rect_x, _rect_y, _rect_x + _rect_width, _rect_y + _rect_height, 16, 16, true);
	
	// meter fill
	var _max_color_rect_width = _rect_width - 4;
	var _color_rect_height = _rect_height - 2;
	var _color_rect_x = _rect_x + 2;
	var _color_rect_y = _rect_y + 1;
	var _meter_percent = (hold_timer / max_hold_timer);
	var _color_rect_width = _max_color_rect_width * _meter_percent;
	draw_set_color(_character_color);
	draw_roundrect_ext(_color_rect_x, _color_rect_y, _color_rect_x + _color_rect_width, _color_rect_y + _color_rect_height, 16, 16, false);
	
}

skip_text_animation = function() {
	FOREACH score_structs ELEMENT
		_elem.current_x = 0;
		_elem.current_points = _elem.points;
	END
}

// event subscriptions
subscribe(id, "end_level", function(game_state = "win") {
	
	if (data_source == undefined || data_source == noone) {
    	return;
	}

	if (game_state == "win") {
		show_debug_message("SHOW VICTORY UI");
		score_structs = [data_source.base_score, data_source.no_lives_lost, data_source.time_bonus, data_source.monster_bonus, data_source.total];
		victory = true;
	}
	
	if (game_state == "lose") {
		show_debug_message("SHOW GAME OVER UI");
		score_structs = [data_source.base_score, data_source.total];
		game_over = true;
	}

});