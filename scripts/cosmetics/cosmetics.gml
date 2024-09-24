function cosmetic_struct(_key = "", _name = "", _sprite = undefined) {
    return {
        key: _key,
        name: _name,
        sprite: _sprite,
    }
}

global.cosmetics = [
    cosmetic_struct("topHat", "Top Hat", spr_top_hat_large),
    cosmetic_struct("bowlerHat", "Bowler Hat", spr_bowler_hat_large),
    cosmetic_struct("cowboyHat", "Cowboy Hat", spr_cowboy_hat_large),
];