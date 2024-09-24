// Feather disable all

/// This is an optional configuration script that you can edit. On boot, Vinyl will import the JSON
/// defined in this script by passing it into VinylSetupImportJSON(). You can configure the
/// entirety of your game audio from this one script in most cases.
/// 
/// If VINYL_LIVE_EDIT is set to <true> then editing this JSON file will quickly be reflected in
/// audio currently playing in your game. The live update feature does have limitations, however.
/// This feature is only available when running on Windows, Mac, or Linux. Furthermore, the GML
/// parser used to power live updating is very simple. You should treat the JSON written in this
/// file as "pure JSON" and you should not use conditionals or if-statements or any logic at all.

global.VinylConfigSON = [
    /*
    Here are some examples of different resources you can create using JSON. This is not an
    exhaustive list; please see "Vinyl JSON Format" for more information.
    
    
    
    // -- Simple sound gain adjustment
    //    All sounds can have their gain adjusted using the following JSON syntax.
    {
        sound: sndJump,
        gain: 0.9,
    },
    
    
    
    // -- Sound randomization
    //    The "shuffle" pattern can be used to choose a random sound to play. Vinyl will try to
    //    ensure that one sound is not repeatedly played.
    {
        shuffle: "coin",
        sound: [sndCoin1, sndCoin2, sndCoin3, sndCoin4, sndCoin5],
    },
    
    
    
    // -- Pitch variance
    //    Shuffle patterns can also be used to randomize pitch for a sound. If you specify a two-
    //    element array then Vinyl will randomize the pitch between those two values. You can also
    //    apply pitch randomization to sound randomization too.
    {
        shuffle: "jump variance",
        sound: sndJump,
        pitch: [1, 1.1],
    },
    
    
    
    // -- Head-Loop-Tail
    //    This kind of pattern will play the "head" sound, then loop the "loop" sound, and then
    //    will play the "tail" sound after that. You should use VinylSetLoop() to control when to
    //    move from the "loop" sound to the "tail" sound.
    {
        hlt: "forest bgm",
        head: sndMusicForestHead,
        loop: sndMusicForestLoop,
        tail: sndMusicForestTail,
        duckOn: "duckering music", //This pattern has additionally been set up on a ducker. See
                                   //below for more information on setting up this feature.
    },
    
    
    
    // -- Blend
    //    The final type of pattern will mix together multiple sounds using the "blend factor" set
    //    by VinylSetBlendFactor(). The default behaviour is to sweep between different sounds but
    //    you can also use an animation curve to control gains.
    {
        blend: "forest ambience",
        sounds: [sndAmbienceForestLow, sndAmbienceForestMid, sndAmbienceForestHigh],
        loop: true,
    },
    
    
    
    // -- Mixes
    //    It's very common to want to adjust the gain of multiple sounds and patterns all at once.
    //    Mixes allow you to do this. Any sound or pattern that is defined as a "member" of a mix
    //    will automatically have its gain adjusted when you adjust the gain for the mix as a
    //    whole. Please note that mixes cannot be defined inside other mixes i.e. there's no
    //    hierarchical mix behaviour.
    {
        mix: "diagetic music",
        members: [
            sndDiageticPiano, //You can list out sounds by reference
            sndDiageticFlute,
            sndDiageticGuitar, 
            {
                sound: sndDiageticDrums,
                gain: 0.9,
            },
        ]
    },
    
    
    
    // -- Duckers
    //    When playing music you'll sometimes want to easily crossfade between tracks such that
    //    only one music track is playing at a time. You'll also sometimes want to allow "strings"
    //    (short pieces of music triggered by special events) to ducker background music tracks.
    //    Both of these effects can be achieved with the "duckOn" feature.
    {
        ducker: "music ducker", //First, we set up the ducker itself
    },
    {
        sound: sndMusicMoon, //Second, we set up a link to a ducker in a sound or pattern
        duckOn: "music ducker",
    },
    {
        mix: "duckering music",
        membersDuckOn: "music ducker", //You can also set up a ducker for multiple sounds at once by
                                     //using the .membersDuckOn property on a mix
        members: [
            sndMusicLava,
            sndMusicWater,
            sndMusicJungle,
            
            {
                sound: sndStingFoundSecret,
                duckPrio: 1, //Sounds can also have a "priority" to control how sounds interact
            },
        ],
    },
    */
    
    // DUCKERS
    {
        ducker: "feedback_ducker",
        duckedGain: 0.7,
        rateOfChange: 1,
    },
    {
        ducker: "UI_ducker",
        duckedGain: 0.6,
        rateOfChange: 1,
    },
    {
        ducker: "music_ducker",
        duckedGain: 0.5,
        rateOfChange: 0.5,
    },
    {
        ducker: "ambient_ducker",
        duckedGain: 0.4,
        rateOfChange: 0.5,
    },
    
    // MIXES
    
    // -- DANGER
    {
        mix: "danger",
        members: [
            {
                sound: snd_die,
                duckPrio: 5,
            },
            {
                sound: snd_fire_projectile,
                duckPrio: 5,
            },
            {
                sound: snd_damaged,
                gain: 2,
                duckPrio: 5,
            },
            {
                sound: snd_spawn,
                duckPrio: 5,
            },
            {
                sound: snd_timer_alarm,
                duckPrio: 5,
            },
            {
                sound: snd_timer_warning,
                duckPrio: 5,
            },
        ],
    },

    // -- FEEDBACK 
    {
        mix: "feedback",
        membersDuckOn: "feedback_ducker",
        members: [
            {
                sound: snd_points,
                duckPrio: 4,
                gain: 1,
            },
            {
                sound: snd_hit,
                duckPrio: 4,
                gain: 1,
            },
            {
                sound: snd_hit_2,
                duckPrio: 4,
                gain: 1,
            },
            {
                sound: snd_shoot,
                duckPrio: 4,
                gain: 1,
            },
            {
                sound: snd_tutorial_success,
                duckPrio: 4,
                gain: 1,
            },
            {
                sound: snd_block_break,
                duckPrio: 4,
            },
            {
                sound: snd_character_switch,
                gain: 0.7,
                duckPrio: 4,
            },
            {
                shuffle: "Death",
                pitch: [0.9, 1.1],
                sound: [snd_death, snd_death_1, snd_death_2, snd_death_3, snd_death_4, snd_death_5],
                duckPrio: 4,
            },
            
            // enemy
            {
                sound: snd_enemy_flip,
                duckPrio: 4,
            },
            {
                sound: snd_enemy_land,
                duckPrio: 4,
            },
            
            // misc
            {
                sound: snd_head_float,
                duckPrio: 4,
            },
            
            // jumping
            {
                sound: snd_jump_big,
                duckPrio: 4,
            },
            {
                sound: snd_jump_normal,
                duckPrio: 4,
            },
            {
                sound: snd_jump_float,
                gain: 0.7,
                duckPrio: 4,
            },
            {
                sound: snd_jump_tall,
                duckPrio: 4,
            },
            {
                sound: snd_jump_small,
                duckPrio: 4,
            },
            {
                sound: snd_jump_spikey,
                duckPrio: 4,
            },
            {
                sound: snd_jump_twin,
                duckPrio: 4,
            },
            {
                sound: snd_land_normal,
                duckPrio: 4,
            },
            
            // landing
            {
                sound: snd_land_tall,
                duckPrio: 4,
            },
            {
                sound: snd_land_small,
                gain: 0.5,
                duckPrio: 4,
            },
            {
                sound: snd_land_big,
                duckPrio: 4,
            },
            {
                sound: snd_land_bounce,
                duckPrio: 4,
            },
            {
                sound: snd_land_float,
                gain: 0.5,
                duckPrio: 4,
            },
            {
                sound: snd_land_spikey,
                duckPrio: 4,
            },
            {
                sound: snd_land_twin_on_twin,
                gain: 2,
                duckPrio: 4,
            },
            {
                sound: snd_land_twin_on_ground,
                gain: 2,
                duckPrio: 4,
            },
            
            // keys
            {
                sound: snd_key_collect,
                duckPrio: 4,
                gain: 0.5,
            },
            {
                sound: snd_key_spawn,
                duckPrio: 4,
                gain: 0.6
            },
        ],
    },
    
    // -- UI
    {
        mix: "UI",
        membersDuckOn: "UI_ducker",
        members: [
            {
                sound: snd_button_back,
                duckPrio: 3,
            },
            {
                sound: snd_button_back_alt,
                duckPrio: 3,
            },
            {
                sound: snd_button_click,
                duckPrio: 3,
            },
            {
                sound: snd_button_click_alt,
                duckPrio: 3,
            },
            {
                sound: snd_button_hover,
                duckPrio: 3,
            },
            {
                sound: snd_level_start_1,
                duckPrio: 3,
            },
            {
                sound: snd_level_start_2,
                duckPrio: 3,
            },
            {
                sound: snd_level_start_3,
                duckPrio: 3,
            },
            {
                sound: snd_level_start_go,
                duckPrio: 3,
            },
            {
                sound: snd_text_bleep,
                duckPrio: 3,
            },
            {
                sound: snd_time_counter,
                duckPrio: 3,
            },
        ],
    },
    
    // -- MUSIC
    {
      mix: "music",
      members: [
        // levels
        {
            sound: snd_combat_music,
            gain: 0.6,
            duckPrio: 2,
        },
        {
            sound: snd_combat_music_1,
            gain: 0.6,
            duckPrio: 2,
        },
        {
            sound: snd_music_level_1_layer_1,
            gain: 0.6,
            duckPrio: 2,
        },
        {
            sound: snd_music_level_1_layer_2,
            gain: 0.6,
            duckPrio: 2,
        },
        {
            sound: snd_music_level_2_layer_1,
            duckPrio: 2,
        },
        {
            sound: snd_music_level_2_layer_2,
            duckPrio: 2,
        },
        {
            sound: snd_music_level_3_layer_1,
            duckPrio: 2,
        },
        {
            sound: snd_music_level_3_layer_2,
            duckPrio: 2,
        },
        {
            sound: snd_music_level_4_layer_1,
            duckPrio: 2,
        },
        {
            sound: snd_music_level_4_layer_2,
            duckPrio: 2,
        },
        {
            sound: snd_music_level_bonus_layer_1,
            duckPrio: 2,
        },
        {
            sound: snd_music_level_bonus_layer_2,
            duckPrio: 2,
        },
        
        // menus
        {
            sound: snd_music_main_menu_layer_1,
            gain: 1,
            duckPrio: 2,
        },
        {
            sound: snd_music_main_menu_layer_2,
            gain: 1,
            duckPrio: 2,
        },
        {
            sound: snd_music_main_menu,
            gain: 1.5,
            duckPrio: 2,
        },
        
        // boss
        {
            sound: snd_music_boss_layer_1,
            duckPrio: 2,
        },
        {
            sound: snd_music_boss_layer_1,
            duckPrio: 2,
        },
        {
            sound: snd_music_boss_layer_3,
            duckPrio: 2,
        },
        {
            sound: snd_music_boss_layer_4,
            duckPrio: 2,
        },
        
        // stingers
        {
            sound: snd_stinger_character_unlock,
            duckPrio: 2,
        },
        {
            sound: snd_stinger_game_over,
            duckPrio: 2,
        },
        {
            sound: snd_stinger_victory,
            duckPrio: 2,
        },
        {
            sound: snd_stinger_level_start,
            duckPrio: 2,
        },
      ],
    },
    
    // -- AMBIENT
    {
        mix: "ambient",
        membersDuckOn: "ambient_ducker",
        members: [
            {
                shuffle: "Footsteps_Normal",
                pitch: [0.9, 1.1],
                sound: [snd_walk_normal_1, snd_walk_normal_2, snd_walk_normal_3, snd_walk_normal_4, snd_walk_normal_5],
                duckPrio: 1,
            },
            {
                shuffle: "Footsteps_Small",
                pitch: [0.9, 1.1],
                sound: [snd_walk_normal_6, snd_walk_normal_7, snd_walk_normal_8, snd_walk_normal_9, snd_walk_normal_10],
                duckPrio: 1,
            },
            {
                shuffle: "Footsteps_Big",
                pitch: [0.9, 1.1],
                sound: [snd_walk_big_1, snd_walk_big_2, snd_walk_big_3, snd_walk_big_4, snd_walk_big_5],
                duckPrio: 1,
            },
            {
                shuffle: "Speech_Medium",
                pitch: [0.9, 1.1],
                sound: [snd_speak_med_7],
                duckPrio: 1,
            },
        ],
    },
];