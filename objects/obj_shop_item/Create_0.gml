item = {};
failed_purchase = false;
successful_purchase = false;
sprite_index = spr_rounded_box;
fail_animation = seq_failed_item_purhase;
success_animation = seq_successful_item_purhase;
sequence = undefined;

failed_purhase_animation = function() {
    if (sequence != undefined && layer_sequence_exists(layer, sequence) && !layer_sequence_is_finished(sequence)) {
        return;
    }
    
    failed_purchase = true;
    alarm_set(0, 60);
    sequence = layer_sequence_create(layer, x,y, fail_animation);
    
    play_sound(snd_button_back);
}

successful_purchase_animation = function() {
    if (sequence != undefined && layer_sequence_exists(layer, sequence) && !layer_sequence_is_finished(sequence)) {
        return;
    }
    
    successful_purchase = true;
    alarm_set(0, 60);
    sequence = layer_sequence_create(layer, x,y, success_animation);
    
    play_sound(snd_button_click);
    play_sound(snd_tutorial_success);
    publish(PURCHASED_ITEM);
}