
// Update character properties
function get_character_properties(_character_key = "") {
	
	if (!is_string(_character_key)) {
		show_debug_message("Error: The provided character key is not a string");
	}
	
	passed_character = _character_key;
	
	var _filter = function(_element, _index) {
		return _element.key == passed_character;
	}
	
	var _matching_character = array_filter(global.character_properties, _filter)
	
	if (is_array(_matching_character)) {
		return _matching_character[0];
	}
	
	return global.character_properties[0];
	
}

function debug_change_character() {
	
	global.character_index += 1;
	
	if (global.character_index > CHARACTER.TWIN_BLUE) {
		global.character_index = 0;
	}
	
	switch_characters(global.character_index);
	
}


// Character Queue
function load_character_queue() {
	
	var _save_data = loadFromJson(global.save_file);
	
	var _unlocked_characters = _save_data.characters;
	
	global.character_queue = _unlocked_characters;
	
	global.queue_index = 0;

}

function save_character_queue(_new_queue = []) {

	if (!is_array(_new_queue)) {
		show_debug_message("Error: the provided queue is not an array");
		return;
	}
	
	if (array_length(_new_queue) == 0) {
		show_debug_message("Error: the provided queue is empty.\nCannot save an empty character queue.");
		return;
	}

	var _save_data = loadFromJson(global.save_file);

	_save_data.characters = _new_queue;
	
	saveToJson(_save_data, global.save_file);

}

function set_character_queue(_new_queue = []) {
	
	if (!is_array(_new_queue)) {
		show_debug_message("Error: the provided character queue is not an array");
	}
	
	global.character_queue = _new_queue;
	
	global.queue_index = 0;

}

function add_to_character_queue(_new_character = 0) {
	
	if (!is_numeric(_new_character)) {
		show_debug_message("Error: Provided Character ID is not an integer");
		return;
	}
	
	if (!array_contains(global.character_queue, _new_character)) {
		array_push(global.character_queue, _new_character);
		save_character_queue(global.character_queue);
	}
	
}

function shuffle_character_queue() {
	
	global.character_queue = array_shuffle(global.character_queue, 1);
	
	array_insert(global.character_queue, 0, CHARACTER.NORMAL);
	
	global.queue_index = 0;
	
}

function get_current_character_in_queue() {
	return global.character_queue[global.queue_index];
}

function get_next_character_in_queue() {
	
	global.queue_index += 1;
	
	if (global.queue_index > array_length(global.character_queue) - 1) {
		global.queue_index = 0;
	}
	
	var _next_character = global.character_queue[global.queue_index];
	
	switch_characters(_next_character);
	
}

function get_character_preview() {
	
	var _local_quque_index = global.queue_index + 1;
	if (_local_quque_index > array_length(global.character_queue) - 1) {
		_local_quque_index = 0;
	}
	
	var _next_character = global.character_queue[_local_quque_index];
	
	return _next_character;	
}