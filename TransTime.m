function time = TransTime(time_old,depot_time_window2)
    total = (18 - 8) * 60; 
    time = time_old / depot_time_window2 * total / 60 + 8;


end