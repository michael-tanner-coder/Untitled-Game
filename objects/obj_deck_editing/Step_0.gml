page_counter.page_count = page_count;
page_counter.current_page = current_page;
page_counter.x = room_width/2 - page_counter.width/2;

if (fsm.event_exists("step")) {
    fsm.step();
}