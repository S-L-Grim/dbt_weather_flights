-- Aggregating weather stats weekly

WITH weekly_weather AS (
    SELECT 
        faa,
        
        -- Extracting the week number and year from the date
        DATE_TRUNC('week', weather_date) AS week_start,

        -- Aggregating temperature metrics
        AVG(temp_avg) AS avg_weekly_temperature,   -- Average temperature for the week
        MAX(temp_max) AS max_weekly_temperature,   -- Maximum temperature for the week
        MIN(temp_min) AS min_weekly_temperature,   -- Minimum temperature for the week

        -- Aggregating precipitation and snowfall (sum for the week)
        SUM(precipitation) AS total_weekly_precipitation,  -- Total precipitation for the week
        SUM(snowfall) AS total_weekly_snowfall,            -- Total snowfall for the week

        -- Aggregating wind metrics
        MODE() WITHIN GROUP (ORDER BY wind_direction) AS mode_weekly_wind_direction, -- Most frequent wind direction
        AVG(wind_speed) AS avg_weekly_wind_speed,     -- Average wind speed for the week
        MAX(peak_wind_gust) AS max_weekly_wind_gust   -- Maximum peak gust for the week

    FROM prep_weather_daily
    GROUP BY faa, DATE_TRUNC('week', weather_date)
)

-- Adding city, country, and name of the airport (optional)
SELECT 
    ww.faa,
    ww.week_start,
    
    -- Weather statistics
    ww.avg_weekly_temperature,
    ww.max_weekly_temperature,
    ww.min_weekly_temperature,
    ww.total_weekly_precipitation,
    ww.total_weekly_snowfall,
    ww.mode_weekly_wind_direction,
    ww.avg_weekly_wind_speed,
    ww.max_weekly_wind_gust,

    -- Optional: Add city, country, and airport name
    ai.city,
    ai.country,
    ai.name

FROM weekly_weather ww
LEFT JOIN prep_airports ai
    ON ww.faa = ai.faa
ORDER BY ww.week_start, ww.faa;