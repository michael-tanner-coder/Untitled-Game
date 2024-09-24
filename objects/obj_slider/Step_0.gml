if (!mouse_check_button(mb_left)) {
	grab = false;
}

if (!grab) {
	exit;
}
else {
	if (mouse_y + yy < bottom_limit && mouse_y + yy > top_limit) {
		y = mouse_y + yy;
	}
	else if(mouse_y + yy > bottom_limit) {
		y = bottom_limit;
	}
	else if (mouse_y + yy < top_limit) {
		y = top_limit;
	}
}

percentage = round(((y-bottom_limit)/(top_limit-bottom_limit))*100);