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
                enemy_count: 5,
                enemy_types: [obj_dot],
                time_between_spawns: 30,
            },    
            {
                enemy_count: 10,
                enemy_types: [obj_dot, obj_big_dot],
                time_between_spawns: 30,
            },    
            {
                enemy_count: 15,
                enemy_types: [obj_dot, obj_big_dot, obj_growing_dot],
                time_between_spawns: 30,
            },    
        ],
    },
    {
        key: "outro",
        map: rm_outro,
    },
];
