global.upgrades = [];
global.default_unlocked_upgrades = ["fire_faster", "move_faster", "get_sturdy"];
global.default_deck = ["fire_faster", "move_faster", "get_sturdy", "fire_faster", "move_faster", "get_sturdy", "fire_faster", "move_faster", "get_sturdy"];
global.deck = global.default_deck;
global.deck_limit = 20;

function pull_from_deck(_card = {}) {
    
}

function effect_struct(_property = "", _value = 0, _operation = OPERATIONS.SET) {
    return {
        property: _property,
        value: _value,
        operation: _operation,
    }
}

function upgrade_struct(_key="", _name="", _description="", _price=0, _sprite=undefined, _effects=[]) {
    return {
        key: _key,
        name: _name,
        description: _description,
        price: _price,
        sprite: _sprite,
        effects: _effects,
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
                500, 
                spr_white_circle, 
                [
                    effect_struct("player_firing_rate", 1.1, OPERATIONS.MULTIPLY),
                ]
        ),
        upgrade_struct(
                "move_faster", 
                "Move Faster", 
                "Increase your move speed by 10% (makes you lighter)", 
                500, 
                spr_white_circle, 
                [
                    effect_struct("player_density", 0.9, OPERATIONS.MULTIPLY),
                ]
        ),
        upgrade_struct(
                "get_sturdy", 
                "Get Heavier", 
                "Increase your weight by 10% (makes you slower)", 
                500, 
                spr_white_circle, 
                [
                    effect_struct("player_density", 1.1, OPERATIONS.MULTIPLY),
                ]
        ),
        // upgrade_struct(
        //         "big_boy", 
        //         "Big Boy", 
        //         "Become huge and hard to move (double your size)", 
        //         1000, 
        //         spr_white_circle, 
        //         [
        //             effect_struct("player_size", 2, OPERATIONS.SET),
        //         ]
        // ),
        // upgrade_struct(
        //         "tiny_baby",
        //         "Tiny Baby", 
        //         "Reduce your size by half",
        //         1000, 
        //         spr_white_circle, 
        //         [
        //             effect_struct("player_size", 0.5, OPERATIONS.SET),
        //         ]
        // ),
        upgrade_struct(
                "fast_fire", 
                "Rapid Fire", 
                "Increase your firing rate by 50% but with weaker bullets",
                1000, 
                spr_white_circle, 
                [
                    effect_struct("player_firing_rate", 0.5, OPERATIONS.MULTIPLY),
                    effect_struct("player_bullet_force", 0.75, OPERATIONS.MULTIPLY),
                ]
        ),
        upgrade_struct(
                "steady_fire", 
                "Steady Fire",
                "Reduce your firing rate by 50% but gain stronger bullets", 
                1000, 
                spr_white_circle, 
                [
                    effect_struct("player_firing_rate", 2, OPERATIONS.MULTIPLY),
                    effect_struct("player_bullet_force", 1.25, OPERATIONS.MULTIPLY),
                ]
        ),
        // upgrade_struct(
        //         "light_weight", 
        //         "Light Weight", 
        //         "Increase your movement speed but you are easier to push", 
        //         1000, 
        //         spr_white_circle, 
        //         [
        //             effect_struct("player_density", 0.75, OPERATIONS.MULTIPLY)
        //         ]
        // ),
        // upgrade_struct(
        //         "heavy_weight", 
        //         "Heavy Weight", 
        //         "Become harder to push but increase your recoil", 
        //         1000, 
        //         spr_white_circle, 
        //         [
        //             effect_struct("player_density", 1.5, OPERATIONS.MULTIPLY),
        //             effect_struct("player_recoil", 1.5, OPERATIONS.MULTIPLY)
        //         ]
        // ),
        upgrade_struct(
                "shot_spread", 
                "Shot Spread", 
                "Increase your shot count by 1, but each shot is weaker", 
                1000, 
                spr_white_circle, 
                [
                    effect_struct("player_shot_count", 1, OPERATIONS.ADD),
                    effect_struct("player_bullet_force", 0.5, OPERATIONS.MULTIPLY),
                ]
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
                4000, 
                spr_white_circle,
                [
                    effect_struct("player_lives", 1, OPERATIONS.ADD),
                ]
        ),
        upgrade_struct(
                "bullet_strength",
                "Bullet Strength",
                "Stronger bullets that hit harder but have greater recoil", 
                4000, 
                spr_white_circle,
                [
                    effect_struct("player_bullet_force", 2, OPERATIONS.MULTIPLY),
                    effect_struct("player_recoil", 2, OPERATIONS.MULTIPLY),
                ]
        ),
        upgrade_struct(
                "closer",
                "The Closer",
                "NEGATIVE RECOIL",
                1000, 
                spr_white_circle,
                [
                    effect_struct("player_recoil", -1, OPERATIONS.MULTIPLY),
                ]
        ),
        // upgrade_struct(
        //         "bomb", 
        //         "Bomb", 
        //         "Right-Click to plant a ticking bomb", 
        //         4000, 
        //         spr_white_circle,
        //         [
        //             effect_struct("player_alt_fire", ABILITIES.BOMB, OPERATIONS.SET),
        //         ]
        // ),
    ];

    return global.upgrades;
}

init_upgrades_collection();
