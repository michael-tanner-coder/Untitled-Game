// Scene data
global.scene_queue = [
    {
        key: "main-menu",
        map: rm_main_menu,
        music_layers: [],
    },
    {
        key: "level",
        map: rm_combat_test,
        goal_score: 20000,
        time_between_spawns: 30,
        max_enemy_count: 10,
        enemy_types: [
            {
                type: obj_dot,
                points: 0,
                limit: 10,
            },
            {
                type: obj_big_dot,
                points: 500,
                limit: 3,
            },
            {
                type: obj_growing_dot,
                points: 1200,
                limit: 2,
            }
        ],
    },
    {
        key: "outro",
        map: rm_outro,
    },
];
