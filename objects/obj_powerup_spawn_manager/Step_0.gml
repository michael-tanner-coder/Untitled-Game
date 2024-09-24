if (spawning_inactive) {
    return;
}

if (instance_number(obj_powerup) <= 0) {
    spawn_timer--;
}

if (spawn_timer <= 0) {
    spawn_powerup();
    spawn_timer = irandom_range(10, 15) * room_speed;
}