if (hit_timer > 0) {
    hit_timer--;
}

if (hit_timer <= 0) {
    hit = false;
}

text_alpha = lerp(text_alpha, 1, 0.02);
