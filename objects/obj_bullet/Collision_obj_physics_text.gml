other.hit = true;
other.hit_timer = 45;
other.text_health -= 1;
other.shake_text(1, 4, 0.5);
instance_destroy(self);
play_sound(snd_hit_2, false);