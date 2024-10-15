WITH weekly_weather AS (
    SELECT 
        airport_code,
        DATE_TRUNC('week', date) AS week_start,
        AVG(avg_temp_c) AS avg_weekly_temperature,
        MAX(max_temp_c) AS max_weekly_temperature,
        MIN(min_temp_c) AS min_weekly_temperature,
        SUM(precipitation_mm) AS total_weekly_precipitation,
        SUM(snow_mm) AS total_weekly_snowfall,
        AVG(avg_wind_direction) AS avg_weekly_wind_direction,
        AVG(avg_wind_speed_kmh) AS avg_weekly_wind_speed,
        MAX(wind_peakgust_kmh) AS max_weekly_wind_gust
    FROM prep_weather_daily
    GROUP BY airport_code, DATE_TRUNC('week', date)
)
SELECT * FROM weekly_weather