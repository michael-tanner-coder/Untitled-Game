var _game_speed = global.settings.game_speed;

if (lives < 1) {
	return;
}

if (hit) {
	score += point_value;
	var _score_text = instance_create_layer(x,y,layer, obj_float_text);
	_score_text.text = "+" + string(round(point_value));
	play_sound(snd_points, false);
	
	with(obj_ui) {
		shake_text(1, round(other.point_value/100), 0.5);
	}
	
	spawn_particles(part_death, x, y);
}

var _shot_spread_angle = 36;
var _shot_spread_count = 10;
var _shoot_direction = 0;

for (var _i = 0; _i < _shot_spread_count; _i++) {
	var _bullet_angle = _shoot_direction + (_i * _shot_spread_angle) - ((_shot_spread_count - 1) * (_shot_spread_angle/2));
	
	var _bullet = instance_create_layer(x +lengthdir_x(sprite_get_width(sprite_index), _shoot_direction)*2, y +lengthdir_y(sprite_get_height(sprite_index), _shoot_direction)*2, layer, obj_enemy_bullet);

    // Bullet force
    var _x_force, _y_force;
    _x_force = lengthdir_x(10, _bullet_angle) * 10 * _game_speed;
    _y_force = lengthdir_y(10, _bullet_angle) * 10 * _game_speed;

    with(_bullet) {
        physics_apply_impulse(x,y,_x_force, _y_force);
    }
}

publish(ENEMY_DEFEATED, round(point_value));

unsubscribe_all(id);