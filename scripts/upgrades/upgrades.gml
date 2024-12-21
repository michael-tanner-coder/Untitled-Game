global.upgrades = [];
global.default_unlocked_upgrades = ["fire_faster", "move_faster", "get_sturdy"];

global.default_deck = [
    {key: "fire_faster", id: gen_id()}, {key: "move_faster", id: gen_id()},{key: "get_sturdy", id: gen_id()},
    {key: "fire_faster", id: gen_id()}, {key: "move_faster", id: gen_id()},{key: "get_sturdy", id: gen_id()},
    {key: "fire_faster", id: gen_id()}, {key: "move_faster", id: gen_id()},{key: "get_sturdy", id: gen_id()},
    {key: "fire_faster", id: gen_id()}, {key: "move_faster", id: gen_id()},{key: "get_sturdy", id: gen_id()},
];
global.deck = get_save_data_property(DECK, global.default_deck);
global.deck_limit = 20;
global.card_type_limit = 3;

global.default_collection = [];
global.collection = get_save_data_property(COLLECTION, global.default_collection);

// Deck functions
function new_card_instance(_key = "") {
    return {key: _key, id: gen_id()};
}

function add_to_deck(_card = {}) {
    if (array_length(global.deck) < global.deck_limit) {
        var _card_count = 0;
        
        FOREACH global.deck ELEMENT
            if (_elem.key == _card.key) {
                _card_count++;  
            }
        END
        
        if (_card_count < global.card_type_limit) {
            array_push(global.deck, _card);
        }
        
        set_save_data_property(DECK, global.deck);
    }
}

function remove_from_deck(_card = {}) {
    var _card_index = undefined;
    FOREACH global.deck ELEMENT
        if (_card.id == _elem.id && _card.key == _elem.key) {
            _card_index = _i;
            break;
        }
    END
    
    if (is_numeric(_card_index)) {
        array_delete(global.deck, _card_index, 1);
        set_save_data_property(DECK, global.deck);
    }
}

function is_in_deck(_card = {}) {
    var _in_deck = false;
    FOREACH global.deck ELEMENT
        if (_elem.id == _card.id) {
            _in_deck = true;
            break;
        }
    END
    return _in_deck;
}

function get_weighted_random_card(_card_collection = []) {
    var _weight_sum = 0;
    
    FOREACH _card_collection ELEMENT
        var _card = _elem;
        _weight_sum += _card.randomness_weight;
    END
    
    var _roll = floor(random_range(0, _weight_sum));
    var _found_card = undefined;
    
    while (_found_card == undefined) {
        FOREACH _card_collection ELEMENT
            var _card = _elem;
            
            if (_roll <= _card.randomness_weight) {
                _found_card = _card;
                break;
            }
            
            _roll -= _card.randomness_weight;
        END
    }
    
    return _found_card;
}

function get_weighted_rare_card(_card_collection = []) {
    var _weight_sum = 0;
    var _rare_cards = [];
    
    FOREACH _card_collection ELEMENT
        if (_elem.randomness_weight <= 50) {
            array_push(_rare_cards, _elem);
        }
    END
    
    FOREACH _rare_cards ELEMENT
        _weight_sum += _elem.randomness_weight;
    END
    
    if (array_length(_rare_cards) <= 0) {
        return get_weighted_random_card(_card_collection);
    }
    
    var _roll = floor(random_range(0, _weight_sum));
    var _found_card = undefined;
    
    while (_found_card == undefined) {
        FOREACH _rare_cards ELEMENT
            var _card = _elem;
            
            if (_roll <= _card.randomness_weight) {
                _found_card = _card;
                break;
            }
            
            _roll -= _card.randomness_weight;
        END
    }
    
    return _found_card;
}


function build_deck_of_structs(_deck = []) {
    var _struct_deck = [];
    FOREACH _deck ELEMENT
        var _card = _elem;
        var _card_struct = get_upgrade_type(_card.key);
        array_push(_struct_deck, _card_struct);
    END
    return _struct_deck;
}

// Collection functions
function add_to_collection(_card = {}) {
    array_push(global.collection, _card);
    set_save_data_property(COLLECTION, global.collection);
}

function remove_from_collection(_card = {}){
    var _removal_index = undefined;
    FOREACH global.collection ELEMENT
        if (_card.id == _elem.id && _card.key == _elem.key) {
            _removal_index = _i;
        }
    END
    
    if (is_numeric(_removal_index)) {
        array_delete(global.collection, _removal_index, 1);
    }
    
    set_save_data_property(COLLECTION, global.collection);
}

function is_in_collection(_card = {}) {
    var _in_collection = false;
    FOREACH global.deck ELEMENT
        if (_elem.id == _card.id) {
            _in_collection = true;
            break;
        }
    END
    return _in_collection;
}

// Card Structs
function effect_struct(_property = "", _value = 0, _operation = OPERATIONS.SET) {
    return {
        property: _property,
        value: _value,
        operation: _operation,
    }
}

function upgrade_struct(_key="", _name="", _description="", _price=0, _sprite=undefined, _effects=[], _randomness_weight = 100) {
    return {
        key: _key,
        name: _name,
        description: _description,
        price: _price,
        sprite: _sprite,
        effects: _effects,
        randomness_weight: _randomness_weight,
    }
}

function get_upgrade_type(_key = "") {
     if (!is_string(_key)) {
        show_debug_message("Error: the provided key is not a string");
        return;
    }
    
    var _matching_upgrade = undefined;
    FOREACH global.upgrades ELEMENT
        var _upgrade = _elem;
        if (_upgrade.key == _key) {
            _matching_upgrade =  _upgrade;
            break;
        }
    END
    
    return _matching_upgrade;
}

function init_upgrades_collection() {
    global.upgrades = [
        upgrade_struct(
                "fire_faster", 
                "Fire Faster", 
                "Increase your fire rate by 10%", 
                1000, 
                spr_white_circle, 
                [
                    effect_struct("player_firing_rate", 1.1, OPERATIONS.MULTIPLY),
                ],
                100
        ),
        upgrade_struct(
                "move_faster", 
                "Move Faster", 
                "Increase your move speed by 10% (makes you lighter)", 
                1000, 
                spr_white_circle, 
                [
                    effect_struct("player_density", 0.9, OPERATIONS.MULTIPLY),
                ],
                100
        ),
        upgrade_struct(
                "get_sturdy", 
                "Get Heavier", 
                "Increase your weight by 10% (makes you slower)", 
                1000, 
                spr_white_circle, 
                [
                    effect_struct("player_density", 1.2, OPERATIONS.MULTIPLY),
                ],
                20
        ),
        upgrade_struct(
                "fast_fire", 
                "Rapid Fire", 
                "Increase your firing rate by 50% but with weaker bullets",
                2000, 
                spr_white_circle, 
                [
                    effect_struct("player_firing_rate", 0.5, OPERATIONS.MULTIPLY),
                    effect_struct("player_bullet_force", 0.5, OPERATIONS.MULTIPLY),
                    effect_struct("player_recoil", 1.3, OPERATIONS.MULTIPLY),
                ]
        ),
        upgrade_struct(
                "steady_fire", 
                "Steady Fire",
                "Reduce your firing rate by 50% but gain stronger bullets", 
                2000, 
                spr_white_circle, 
                [
                    effect_struct("player_firing_rate", 2, OPERATIONS.MULTIPLY),
                    effect_struct("player_bullet_force", 2.5, OPERATIONS.MULTIPLY),
                ]
        ),
        upgrade_struct(
                "shot_spread", 
                "Shot Spread", 
                "Increase your shot count by 1, but each shot is weaker", 
                2000, 
                spr_white_circle, 
                [
                    effect_struct("player_shot_count", 1, OPERATIONS.ADD),
                    effect_struct("player_bullet_force", 0.5, OPERATIONS.MULTIPLY),
                ],
                50
        ),
        // upgrade_struct(
        //         "shot_focus", 
        //         "Shot Focus", 
        //         "Decrease your shot count by 1, but each shot is stronger", 
        //         1000, 
        //         spr_white_circle,
        //         [
        //             effect_struct("player_shot_count", 1, OPERATIONS.SUBTRACT),
        //             effect_struct("player_bullet_force", 2, OPERATIONS.DIVIDE),
        //         ]
        // ),
        upgrade_struct(
                "extra_life", 
                "Extra Life", 
                "Gain 1 extra life",
                6000, 
                spr_white_circle,
                [
                    effect_struct("player_lives", 1, OPERATIONS.ADD),
                ],
                0,
        ),
        upgrade_struct(
                "bullet_strength",
                "Bullet Strength",
                "Stronger bullets that hit harder but have greater recoil", 
                4000, 
                spr_white_circle,
                [
                    effect_struct("player_bullet_force", 4, OPERATIONS.MULTIPLY),
                    effect_struct("player_recoil", 2, OPERATIONS.MULTIPLY),
                ],
                20
        ),
        upgrade_struct(
                "closer",
                "The Closer",
                "NEGATIVE RECOIL",
                2000, 
                spr_white_circle,
                [
                    effect_struct("player_recoil", -1, OPERATIONS.MULTIPLY),
                ],
                10
        ),
        upgrade_struct(
                "revive",
                "Revive",
                "Retrieve 1 card from the discard pile",
                200, 
                spr_white_circle,
                [
                    effect_struct("retrieve_discard_pile", 1, OPERATIONS.NONE),
                ],
                100
        ),
    ];

    return global.upgrades;
}

init_upgrades_collection();
