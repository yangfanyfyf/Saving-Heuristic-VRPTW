function time = TimeTrans(time_old)
    % 调整时间的格式
    v_km_h = 1; 
    v_m_min = v_km_h * 1000 / 60;
    time = (time_old - 8) * 60 * v_m_min;
end
