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

global.upgrades = [
    upgrade_struct(
            "bigBoy", 
            "Big Boy", 
            "Become huge and hard to move (double your size)", 
            1000, 
            spr_white_circle, 
            [
                effect_struct("player_size", 2, OPERATIONS.SET),
            ]
    ),
    upgrade_struct(
            "tinyBaby",
            "Tiny Baby", 
            "Reduce your size by half", 
            1000, 
            spr_white_circle, 
            [
                effect_struct("player_size", 0.5, OPERATIONS.SET),
            ]
    ),
    upgrade_struct(
            "fastFire", 
            "Fast Fire", 
            "Increase your firing rate (difficult to control)", 
            1000, 
            spr_white_circle, 
            [
                effect_struct("player_firing_rate", 0.5, OPERATIONS.MULTIPLY),
            ]
    ),
    upgrade_struct(
            "steadyFire", 
            "Steady Fire", 
            "Stabilize your firing rate (slow but easy to control)", 
            1000, 
            spr_white_circle, 
            [
                effect_struct("player_firing_rate", 2, OPERATIONS.MULTIPLY),
            ]
    ),
    upgrade_struct(
            "lightWeight", 
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
            "heavyWeight", 
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
            "shotSpread", 
            "Shot Spread", 
            "Increase your shot count by 1", 
            1000, 
            spr_white_circle, 
            [
                effect_struct("player_shot_count", 1, OPERATIONS.ADD),
            ]
    ),
    upgrade_struct(
            "extraLife", 
            "Extra Life", 
            "Gain 1 extra life", 
            4000, 
            spr_white_circle,
            [
                effect_struct("player_lives", 1, OPERATIONS.ADD),
            ]
    ),
    upgrade_struct(
            "bulletStrength", 
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