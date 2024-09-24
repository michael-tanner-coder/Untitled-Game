// Tutorial Data
global.tutorials = [
    {
        flag: "demo_build",
        prompts: [
            {
                text: "Hi, there!",
                inputs: ["jump"],      // multiple valid inputs for one tutorial prompt
            },
            {
                text: "I've built a quick demo build of the game that takes you through each character and some sample levels.\nNothing in the build is final but it should give an idea of the game.",
                inputs: ["jump"],  
            },
            {
                text: "Swaplings is a game about a bunch weird little guys made in a lab. But today, they're busting out.",
                inputs: ["jump"],  
            },
            {
                text: "No story sequences will be in this build. Just basic gameplay.",
                inputs: ["jump"],
            },
            {
                text: "Okay, that's enough for now. Let's get started.",
                inputs: ["jump"],
                on_exit_events: [FINISHED_SCENE],
            },
        ],
    },
    {
        flag: "played_normal_character",
        prompts: [
            {
                text: "MOVE",
                inputs: ["left", "right"],      // multiple valid inputs for one tutorial prompt
                time: 250,                      // time (in steps) for how long the prompt is active after the player first presses a valid input 
                on_enter_events: [DISABLED_ENEMY_SPAWNING, DISABLED_KEY_SPAWNING],
            },
            {
                text: "JUMP",                   // name of the tutorial concept
                inputs: ["jump"],               // input the player must make to progress
                count: 3,                       // number of times the player must make the input
            },
            {
                text: "FALL FAST (while in air)",
                inputs: ["down"],
                events: [FELL_FAST],
                time: 150,
            },
            {
                text: "Switch your [ORANGE]Swaplings[/ORANGE][c_white] by touching the beams",
                count: 3,
                events: [PLAYER_WARPED],
                on_enter_events: [CHARACTER_QUEUE_UPDATED + " " + string(CHARACTER.NORMAL) + " " + string(CHARACTER.TALL)],
            },
            {
                text: "As [GREEN]Green[/GREEN][c_white]: Bump blocks with your head",
                events: [BUMPED_BLOCK],
                count: 3,
            },
            {
                text: "As [GREEN]Green[/GREEN][c_white]: Flip over enemies by bumping blocks; jump on them",
                on_enter_events: [ENABLED_ENEMY_SPAWNING],
                events: [ENEMY_DEFEATED],
                count: 1,
            },
            {
                text: "Collect enough keys to deactivate the beams",            
                events: [COLLECTED_KEY],        // events that must be published in order to progress
                count: 3,                       // number of times the event must be published
                on_enter_events: [ENABLED_ENEMY_SPAWNING, ENABLED_KEY_SPAWNING], // events to publish when the prompt first activates. Event params are separated by spaces 
            },
            {
                text: "Some enemies will have keys inside them",            
                events: [COLLECTED_KEY],        // events that must be published in order to progress
                count: 2,                       // number of times the event must be published
                on_enter_events: [SPAWN_ONLY_KEY_ENEMIES, DISABLED_KEY_SPAWNING], // events to publish when the prompt first activates. Event params are separated by spaces 
                on_exit_events: [WON_LEVEL],    // events to publish when we finish this prompt
            },
        ],
    },
    {
        flag: "played_tall_character",
        prompts: [
            {
                text: "Bump blocks with your head",
                events: [BUMPED_BLOCK],
                on_enter_events: [DISABLED_KEY_SPAWNING],
                count: 3,
            },
            {
                text: "Flip over enemies by bumping blocks; jump on them",
                events: [ENEMY_DEFEATED],
                count: 2,
            },
            {
                text: "Swap characters by touching the beam",
                count: 2,
                events: [PLAYER_WARPED],
                on_enter_events: [CHARACTER_QUEUE_UPDATED + " " + string(CHARACTER.TALL) + " " + string(CHARACTER.NORMAL)],
            },
            {
                text: "Collect keys",            
                events: [COLLECTED_KEY],       
                count: 3,
                on_enter_events: [ENABLED_KEY_SPAWNING],
                on_exit_events: [WON_LEVEL]
            },
        ],
    },    
    {
        flag: "played_small_character",
        prompts: [
            {
                text: "Jump higher and faster",
                inputs: ["jump"],
                on_enter_events: [SPAWN_NO_KEY_ENEMIES, DISABLED_ENEMY_SPAWNING, DISABLED_KEY_SPAWNING],
                count: 3,
            },
            {
                text: "Work with other [ORANGE]Swaplings[/ORANGE][c_white] to collect keys",            
                events: [COLLECTED_KEY],       
                count: 5,
                on_enter_events: [ENABLED_KEY_SPAWNING, CHARACTER_QUEUE_UPDATED + " " + string(CHARACTER.SMALL) + " " + string(CHARACTER.TALL)],
                on_exit_events: [WON_LEVEL]
            },
        ],
    },
    {
        flag: "played_big_character",
        prompts: [
            {
                text: "Jump to stomp the ground",
                inputs: ["jump"],
                count: 3,
                on_enter_events: [DISABLED_ENEMY_SPAWNING, DISABLED_KEY_SPAWNING],
            },
            {
                text: "Flip over enemies with your stomps and smash them",
                count: 1,
                events: [ENEMY_DEFEATED],
                on_enter_events: [ENABLED_ENEMY_SPAWNING],
            },
            {
                text: "Work with other [ORANGE]Swaplings[/ORANGE][c_white] to collect keys",            
                events: [COLLECTED_KEY],       
                count: 3,
                on_enter_events: [ENABLED_KEY_SPAWNING, CHARACTER_QUEUE_UPDATED + " " + string(CHARACTER.BIG) +  " " + string(CHARACTER.SMALL) + " " + string(CHARACTER.TALL)],
                on_exit_events: [WON_LEVEL]
            },
        ],
    },    
    {
        flag: "played_spikey_character",
        prompts: [
            {
                text: "Break blocks with your spike",
                events: [DISABLED_ENEMY_SPAWNING, DISABLED_KEY_SPAWNING, DESTROYED_BLOCK],
                count: 3,
            },
            {
                text: "Destroy enemies with your spike",
                count: 2,
                on_enter_events: [ENABLED_ENEMY_SPAWNING],
                events: [ENEMY_DEFEATED],
            },
            {
                text: "Collect keys",            
                events: [COLLECTED_KEY],       
                count: 3,
                on_enter_events: [ENABLED_KEY_SPAWNING, CHARACTER_QUEUE_UPDATED + " " + string(CHARACTER.SPIKEY) +  " " + string(CHARACTER.NORMAL) + " " + string(CHARACTER.TALL)],
                on_exit_events: [WON_LEVEL]
            },
        ],
    },
    {
        flag: "played_bounce_character",
        prompts: [
            {
                text: "Break blocks while moving",
                events: [DESTROYED_BLOCK],
                on_enter_events: [DISABLED_KEY_SPAWNING, DISABLED_ENEMY_SPAWNING],
                count: 6,
            },
            {
                text: "Time your jumps to bounce higher",
                inputs: ["jump"],
                count: 3,
            },
            {
                text: "Destroy enemies by bouncing on them",
                events: [ENEMY_DEFEATED],
                count: 2,
                on_enter_events: [ENABLED_ENEMY_SPAWNING],
            },
            {
                text: "Collect keys",            
                events: [COLLECTED_KEY],       
                count: 3,
                on_enter_events: [ENABLED_KEY_SPAWNING],
                on_exit_events: [WON_LEVEL]
            },
        ],
    },   
    {
        flag: "played_twin_character",
        prompts: [
            {
                text: "You control the red twin",
                time: 250,
                on_enter_event: [DISABLED_ENEMY_SPAWNING, DISABLED_KEY_SPAWNING],
            },
            {
                text: "The blue twin won't take damage",
                time: 150,
                count: 1,
                on_enter_events: [SPAWN_NO_KEY_ENEMIES, ENABLED_ENEMY_SPAWNING],
            },
            {
                text: "Both twins can collect keys",            
                events: [COLLECTED_KEY],
                count: 3,
                on_enter_events: [ENABLED_KEY_SPAWNING],
                on_exit_events: [WON_LEVEL]
            },
        ],
    },
    {
        flag: "played_float_character",
        prompts: [
            {
                text: "Raise/lower your head",
                inputs: ["up"],
                count: 2,
                on_enter_events: [SPAWN_NO_KEY_ENEMIES, DISABLED_ENEMY_SPAWNING, DISABLED_KEY_SPAWNING],
            },
            {
                text: "Your head and feet are both vulnerable",
                on_enter_events: [SPAWN_NO_KEY_ENEMIES, ENABLED_ENEMY_SPAWNING],
                time: 200,
            },
            {
                text: "Collect keys",            
                events: [COLLECTED_KEY],       
                count: 3,
                on_enter_events: [ENABLED_KEY_SPAWNING],
                on_exit_events: [WON_LEVEL]
            },
        ],
    },    
];


// Tutorial Scripts
function check_if_tutorial_flag_is_valid(_flag = "") {
     if (!is_string(_flag)) {
        show_debug_message("Error: provided tutorial flag is not a string");
        return false;
    }
    
    return true;
}

function get_tutorial_sequence(_flag = "") {
   if (!check_if_tutorial_flag_is_valid(_flag)) {
       return;
   }
    
    var _found_tutorial = undefined;
    FOREACH global.tutorials ELEMENT
        var _tutorial = _elem;
        var _tutorial_flag = struct_get(_tutorial, "flag");
        if (_tutorial_flag == _flag) {
            _found_tutorial = _tutorial;
            break;
        }
    END
    
    return _found_tutorial;
}

function check_if_tutorial_was_finished(_flag = "") {
    if (!check_if_tutorial_flag_is_valid(_flag)) {
       return;
    }
    
    return get_flag(_flag);
}

function complete_tutorial(_flag = "") {
   if (!check_if_tutorial_flag_is_valid(_flag)) {
       return;
   }
   
   set_flag(_flag, true);
}