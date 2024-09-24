var _temp_data_source = undefined;
with(obj_game_manager) {
    _temp_data_source = self;
}
data_source = _temp_data_source;
font = fnt_header;
drawn_score = score;

// Positioning
left_ui_start_x = 40;
left_ui_start_y = 50;
right_ui_start_x = 1504;
character_preview_start_y = left_ui_start_y;

// Spacing
life_sprite_padding = 4;
text_group_padding = 64;

// Sizing
pillar_box_width = 32 * 13;

// Color
header_text_color = c_black;
paragraph_text_color = c_white;
timer_color = paragraph_text_color;
outline_text_color = c_white;

// Key Meter
current_meter_fill_percent = 0;

subscribe(id, WARNING_SOUNDED, function() {
    timer_color = YELLOW;
});

subscribe(id, ALARM_SOUNDED, function() {
    timer_color = RED;
});

subscribe(id, PURCHASED_ITEM, function() {
    play_sound(snd_time_counter);
})
