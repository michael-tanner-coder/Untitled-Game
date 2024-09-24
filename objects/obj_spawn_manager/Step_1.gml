// get number of currently active enemies
var _spawn_count = 0;
FOREACH spawn_types ELEMENT
	_spawn_count += instance_number(_elem);
END
spawn_count = _spawn_count;