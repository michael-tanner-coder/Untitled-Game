/// @description Insert description here
// You can write your code in this editor

tile_size = 120/2;

rows = ceil(HEIGHT / tile_size);
cols = ceil(WIDTH / tile_size);

random_col = tile_size * irandom(cols - 1);
random_row = tile_size * irandom(rows - 1);

alarm[0] = 60;

function respond_to_event(_payload) {
	show_debug_message("EVENT WAS PUBLISHED");
	show_debug_message(string(_payload));
}

function response() {
	set_locale("es");
	show_debug_message(str("dialog.hello", {name: "Michael"}));
}

subscribe(id, "my_event", response);