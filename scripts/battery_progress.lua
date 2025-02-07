function conky_battery_progress()
    local capacity = tonumber(conky_parse("${battery_percent BAT0}"))
    local status = conky_parse("${battery_status BAT0}")

    -- Define darker colors based on battery level
    local color
    if capacity <= 10 then
        color = "#B20000" -- Darker Red (0-10%)
    elseif capacity <= 30 then
        color = "#CC7A00" -- Darker Orange (10-30%)
    elseif capacity <= 50 then
        color = "#CCCC00" -- Darker Yellow (30-50%)
    elseif capacity <= 70 then
        color = "#7FBFD2" -- Darker Light Blue (50-70%)
    elseif capacity <= 90 then
        color = "#66CC66" -- Darker Light Green (70-90%)
    else
        color = "#00B200" -- Darker Green (90-100%)
    end

    -- Generate the progress bar using conky_parse to evaluate Conky variables
    local bar = conky_parse(string.format(
        '${color %s}${execbar 10,300 echo "%d"}',
        color, capacity
    ))

    return bar
end

