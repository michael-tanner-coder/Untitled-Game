page_counter.page_count = page_count;
page_counter.current_page = current_page;

if (fsm.event_exists("step")) {
    fsm.step();
}