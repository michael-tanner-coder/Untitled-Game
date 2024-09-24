color_index += 1;
if (color_index > array_length(colors) - 1) {
    color_index = 0;
}
alarm_set(0, color_change_time);