/// @description camera and UI init

set_camera(0, 0, INIT_WIDTH, INIT_HEIGHT); 
set_gui_size(INIT_WIDTH); 

if os_type == os_windows or os_type == os_linux or os_type == os_macosx 
then window_center(); //this will center the window