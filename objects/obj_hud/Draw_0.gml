draw_set_valign(fa_middle);
if (data_source == undefined || data_source == noone) {
    return;
}

var _level_key = struct_get(get_current_scene(), "key");

draw_set_font(font);
draw_set_color(paragraph_text_color);

var _label_height = string_height("LABEL");

var _current_character = get_current_character_in_queue();
if (_current_character > array_length(global.character_properties) - 1) {
    return;
}

var _current_character_properties = global.character_properties[_current_character];
header_text_color = struct_get(_current_character_properties, "color");


// -- LEFT PILLAR BOX --
draw_set_halign(fa_left);
// LIVES
draw_set_font(fnt_paragraph);
draw_sprite(spr_life, 0, left_ui_start_x + life_sprite_padding, left_ui_start_y);
draw_text(left_ui_start_x + life_sprite_padding + sprite_get_width(spr_life), left_ui_start_y + sprite_get_height(spr_life)/4, " x " + string(lives));

// SCORE
draw_set_font(font);
var _score_y = left_ui_start_y + _label_height;
draw_set_color(paragraph_text_color);
var _formatted_score = string_format(round(drawn_score), 8, 0);
draw_text(left_ui_start_x, _score_y, string_replace_all(_formatted_score, " ", "0"));

// TIME
if (!data_source.is_tutorial_scene) {
    var _time_y = _score_y + _label_height;
    draw_sprite(spr_time, 0, left_ui_start_x, (_time_y - sprite_get_height(spr_time)/2) + 2);
    draw_set_color(timer_color);
    draw_text(left_ui_start_x + sprite_get_width(spr_time) + life_sprite_padding, _time_y, string(floor(data_source.timer)));
}

// KEYS
var _key_grid_y = 300;

if (!data_source.is_tutorial_scene) {
	var _key_meter_x = left_ui_start_x + sprite_get_width(spr_key)/2;
    draw_sprite(spr_key, 0, _key_meter_x, _key_grid_y);
	var _rect_width = 244;
	var _rect_height = 39*2;
	var _border_radius = 64;
    
    // meter outline
	var _rect_x = (_key_meter_x + sprite_get_width(spr_key));
	var _rect_y = (_key_grid_y - _rect_height/2);
	draw_set_color(WHITE);
	draw_sprite_ext(spr_key_meter_outline, 0, _rect_x, _rect_y, 1, 1, 0, WHITE, 1);
	
	// meter fill
	var _color_rect_x = _rect_x + 4;
	var _color_rect_y = _rect_y + 4;
	var _meter_percent = (data_source.collected_keys / data_source.goal_key_count);
	current_meter_fill_percent = lerp(current_meter_fill_percent, _meter_percent, 0.1);
	draw_set_color(WHITE);
	draw_sprite_ext(spr_key_meter_fill, 0, _color_rect_x, _color_rect_y, current_meter_fill_percent, 1, 0, WHITE, 1);
}

// LEVEL INFO
if (global.debug) {
    var _level_y = 900;
    draw_set_halign(fa_center);
    draw_set_color(paragraph_text_color);
    draw_text(left_ui_start_x + sprite_get_width(spr_key_outline_for_grid) * 1.5, _level_y, string(_level_key));
}

// -- RIGHT PILLAR BOX --

// ACTIVE POWERUPS
var _powerup_margin = 34;
var _powerup_spawn_list_y = left_ui_start_y + sprite_get_height(spr_rounded_box_short) + sprite_get_height(spr_powerup_bubble);
var _powerup_spawn_list_x = right_ui_start_x + (_powerup_margin * 3);
for(var _i = 0; _i < global.max_powerups_list_size; _i++) {
    if (array_length(global.powerups_spawn_list) > _i && global.powerups_spawn_list[_i]) {
        var _powerup = global.powerups_spawn_list[_i];
        var _sprite_width = sprite_get_width(_powerup.sprite);
        draw_sprite(_powerup.sprite, 0, _powerup_spawn_list_x + _i * (_sprite_width + _powerup_margin), _powerup_spawn_list_y);
    }
    else {
        var _sprite_width = sprite_get_width(spr_circle_outline);
        draw_sprite(spr_circle_outline, 0, _powerup_spawn_list_x + _i * (_sprite_width + _powerup_margin), _powerup_spawn_list_y);
    }
}
    
// CHARACTER PREVIEW
var _next_character = get_character_preview();
if (_next_character > array_length(global.character_properties) - 1) {
    return;
}
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var _next_character_properties = global.character_properties[_next_character];
var _box_height = sprite_get_height(spr_rounded_box_short);
var _box_top_margin = 50;
draw_sprite_ext(spr_rounded_box_short, 0, right_ui_start_x + pillar_box_width/2, (_box_height/2) + _box_top_margin, 1, 1, 0, c_white, 1);
draw_sprite_ext(_next_character_properties.idle, 0, right_ui_start_x + pillar_box_width/2, (_box_height/2) + _box_top_margin, 1, 1, 0, c_white, 1);
draw_outlined_text(right_ui_start_x + pillar_box_width/2, _box_height + _box_top_margin, string_upper("next"), header_text_color, font, 4, outline_text_color);