// Tutorial Data
global.tutorials = [
    {
        flag: "basics_tutorial",
        prompts: [
            {
                text: "Move",
                inputs: ["left", "right", "up", "down"],
                on_enter_events: [DISABLED_ENEMY_SPAWNING, DISABLED_MONEY_SPAWNING],
            },
            {
                text: "Shoot",
                inputs: ["shoot"],  
            },
            {
                text: "Dash",
                inputs: ["alt"],  
                on_exit_events: [ENABLED_ENEMY_SPAWNING],
            },
            {
                text: "Push other SLIMES into spikes",
                events: [ENEMY_DEFEATED],
                count: 3,
                on_exit_events: [ENABLED_MONEY_SPAWNING],
            },
        ],
    },
    {
        flag: "card_tutorial",
        prompts: [
            {
                text: "View the CARDS in your HAND",
                inputs: ["view_hand"],      // multiple valid inputs for one tutorial prompt
            },
            {
                text: "Activate a CARD with MONEY",                   // name of the tutorial concept
                inputs: ["select_card"],               // input the player must make to progress
                events: [UPGRADE_SELECTED],
                count: 3,                       // number of times the player must make the input
            },
            {
                text: "Earning enough points will let you draw a CARD",
                events: [DRAW_CARD_IS_AVAILABLE],
            },
            {
                text: "Draw a CARD",
                inputs: ["draw_card"],
                count: 1,
            },
            {
                text: "If your HAND is full, you can DISCARD",
                events: [DISCARD_CARD],
                count: 1,
            },
            {
                text: "Reach 20,000 points to summon the BOSS SLIME. Good luck :)",            
                time: 150,                       // number of times the event must be published
                on_enter_events: [ENABLED_ENEMY_SPAWNING, ENABLED_MONEY_SPAWNING], // events to publish when the prompt first activates. Event params are separated by spaces 
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