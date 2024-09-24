
/*
struct = {
    "event name" = [
        [id, func],
        ...,
        [id, func]
    ],
    ...,
    "event name" = [
        [id, func],
        ...,
        [id, func]
    ],
}
*/

enum PS_EVENT {
    INST_ID = 0,
    INST_FUNC = 1,
}

global.event_struct = {};

/**
 * @description Subscribe the given instance to the given event in the pubsub_manager
 * and optionally include a callback function
 * @param {real} _id
 * @param {string} _event
 * @param {Function} _func
 * @returns {null}
 */
function subscribe(_id, _event, _func) {
    if (is_undefined(global.event_struct[$ _event])) {
        global.event_struct[$ _event] = [];
    } else if (is_subscribed(_id, _event) != -1) {
        return;
    }
    array_push(global.event_struct[$ _event], [_id, _func]);
}

/**
 * @description Publish the given event in the pubsub_manager and invoke all subscriber callbacks
 * @param {string} _event
 * @param {any} _data
 */
function publish(_event, _data = 0) {
    var _subscriber_array = global.event_struct[$ _event];
    
    if (is_undefined(_subscriber_array)) {
        return;
    }

    for (var i = array_length(_subscriber_array) - 1; i >= 0; i--) {
        if (instance_exists(_subscriber_array[i][PS_EVENT.INST_ID])) {
            _subscriber_array[i][PS_EVENT.INST_FUNC](_data);
        }else {
            array_delete(_subscriber_array, i, 1);
        }
    }
}

/**
 * @description Checked if the given instance ID is listed as a subscriber to the given event.
 * 
 * Returns the index of the subscriber's record in the list of event subscribers.
 * 
 * Returns -1 if no subscription is found.
 * @param {number} _id
 * @param {string} _event
 * @returns {real}
 */
function is_subscribed(_id, _event) {
    for(var _i = 0; _i < array_length(global.event_struct[$ _event]); _i+=1) {
        if (global.event_struct[$ _event][_i][PS_EVENT.INST_ID] == _id) {
            return _i;
        }
    }
    return -1;
}

/** Removed the subscriber's ID record from the subscriber list for the given event
 * @param {number} _id
 * @param {string} _event
 */
function unsubscribe(_id, _event) {
    if (is_undefined(global.event_struct[$ _event])) {
        return;
    }

    var _pos = is_subscribed(_id, _event);
    if (_pos != -1) {
        array_delete(global.event_struct[$ _event], _pos, 1);
    }
}

/**
 * @description Invokes the unsubscribe function for all events to which the given instance is subscribed
 * @param {real} _id
 */
function unsubscribe_all(_id) {
    // GML method for looping through a struct
    var _keys_array = variable_struct_get_names(global.event_struct);
    for(var i = (array_length(_keys_array) - 1); i >= 0; i--) {
        unsubscribe(_id, _keys_array[i]);
    }
}

/**
 * @description Remove the given event type from the event struct. 
 * 
 * This will also remove all subscriptions to this event.
 * @param {string} _event
 */
function remove_event(_event) {
    if (variable_struct_exists(global.event_struct, _event)) {
        variable_struct_remove(global.event_struct, _event);
    }
}

/**
 * @description Remove all entries in the event struct and reset the struct to an empty object
 */
 function remove_all_events() {
    delete global.event_struct;
    global.event_struct = {};
}

/**
 * @description Removes all "dead" instance IDs from the event struct along with their subscriptions
 */
 function remove_dead_instance_ids() {
    var _keys_array = variable_struct_get_names(global.event_struct);
    for (var i = 0; i < array_length(_keys_array); i++) {
        var _keys_array_subs = global.event_struct[$ _keys_array[i]];
        for (var j = array_length(_keys_array_subs) - 1; j >= 0; j++) {
            if (!instance_exists(_keys_array_subs[j][0])) {
                array_delete(global.event_struct[$ _keys_array[i]], j, 1);
            }
        }
    }
}