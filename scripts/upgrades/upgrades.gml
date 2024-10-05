global.upgrades = [];
global.default_unlocked_upgrades = ["fast_fire", "steady_fire", "bullet_strength"];

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

function init_upgrades_collection() {
    global.upgrades = [
    upgrade_struct(
            "big_boy", 
            "Big Boy", 
            "Become huge and hard to move (double your size)", 
            1000, 
            spr_white_circle, 
            [
                effect_struct("player_size", 2, OPERATIONS.SET),
            ]
    ),
    upgrade_struct(
            "tiny_baby",
            "Tiny Baby", 
            "Reduce your size by half", 
            1000, 
            spr_white_circle, 
            [
                effect_struct("player_size", 0.5, OPERATIONS.SET),
            ]
    ),
    upgrade_struct(
            "fast_fire", 
            "Fast Fire", 
            "Increase your firing rate (difficult to control)", 
            1000, 
            spr_white_circle, 
            [
                effect_struct("player_firing_rate", 0.5, OPERATIONS.MULTIPLY),
            ]
    ),
    upgrade_struct(
            "steady_fire", 
            "Steady Fire", 
            "Stabilize your firing rate (slow but easy to control)", 
            1000, 
            spr_white_circle, 
            [
                effect_struct("player_firing_rate", 2, OPERATIONS.MULTIPLY),
            ]
    ),
    upgrade_struct(
            "light_weight", 
            "Light Weight", 
            "Increase your movement speed but your shots have more recoil", 
            1000, 
            spr_white_circle, 
            [
                effect_struct("player_density", 0.5, OPERATIONS.MULTIPLY),
                effect_struct("player_recoil", 2, OPERATIONS.MULTIPLY)
            ]
    ),
    upgrade_struct(
            "heavy_weight", 
            "Heavy Weight", 
            "Decrease your recoil but you move more slowly", 
            1000, 
            spr_white_circle, 
            [
                effect_struct("player_density", 0.5, OPERATIONS.DIVIDE),
                effect_struct("player_recoil", 2, OPERATIONS.DIVIDE)
            ]
    ),
    upgrade_struct(
            "shot_spread", 
            "Shot Spread", 
            "Increase your shot count by 1", 
            1000, 
            spr_white_circle, 
            [
                effect_struct("player_shot_count", 1, OPERATIONS.ADD),
            ]
    ),
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
            "bomb", 
            "Bomb", 
            "Right-Click to plant a ticking bomb", 
            4000, 
            spr_white_circle,
            [
                effect_struct("player_alt_fire", ABILITIES.BOMB, OPERATIONS.SET),
            ]
    ),
];

    return global.upgrades;
}
