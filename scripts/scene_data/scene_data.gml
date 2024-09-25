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
        waves: [
            {
                enemy_count: 4,
                max_enemy_count: 1,
                enemy_types: [obj_dot],
                time_between_spawns: 20,
                time_between_increasing_enemy_limit: 5,
            },    
            {
                enemy_count: 10,
                max_enemy_count: 5,
                enemy_types: [obj_dot, obj_big_dot],
                time_between_spawns: 30,
                time_between_increasing_enemy_limit: 4,
            },    
            {
                enemy_count: 30,
                max_enemy_count: 10,
                enemy_types: [obj_dot, obj_dot, obj_dot, obj_big_dot, obj_growing_dot],
                time_between_spawns: 20,
                time_between_increasing_enemy_limit: 2,
            },    
        ],
    },
    {
        key: "outro",
        map: rm_outro,
    },
];
