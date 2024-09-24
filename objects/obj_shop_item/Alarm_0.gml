failed_purchase = false;
layer_sequence_destroy(sequence);

if (successful_purchase) {
    instance_destroy(self);
}