var _max_speed = 200 * global.settings.game_speed;
phy_linear_velocity_x=clamp(phy_linear_velocity_x,-_max_speed,_max_speed);
phy_linear_velocity_y=clamp(phy_linear_velocity_y,-_max_speed,_max_speed);