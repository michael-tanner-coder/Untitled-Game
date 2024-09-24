function lab_log_struct(_key = "", _title = "", _content = "") {
    return {
        key: _key,
        title: _title,
        content: _content,
    }
}

global.lab_logs = [
    lab_log_struct("log1", "Dear Diary ...", "Lorem ipsum and so on ..."),    
    lab_log_struct("log2", "My experiments", "I've finally figured it out ..."),    
    lab_log_struct("log3", "Today's Lunch ...", "I can't keep eating Taco Bell, man ..."),    
];