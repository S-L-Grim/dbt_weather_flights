WITH flight_weather AS (
    SELECT 
        f.origin AS faa,
        f.flight_date,
        COUNT(DISTINCT f.flight_number) AS nunique_departures,
        COUNT(DISTINCT f.flight_number) AS nunique_arrivals,
        COUNT(f.sched_dep_time) AS planned_departures,
        COUNT(f.sched_arr_time) AS planned_arrivals,
        SUM(f.cancelled) AS total_cancelled,
        SUM(f.diverted) AS total_diverted,
        COUNT(f.arr_time) AS actual_departures,
        COUNT(f.arr_time) AS actual_arrivals,
        AVG(w.avg_temp_c) AS daily_avg_temp,
        MAX(w.max_temp_c) AS daily_max_temp,
        MIN(w.min_temp_c) AS daily_min_temp,
        SUM(w.precipitation_mm) AS daily_precipitation,
        SUM(w.snow_mm) AS daily_snowfall,
        AVG(w.avg_wind_direction) AS avg_wind_direction,
        AVG(w.avg_wind_speed_kmh) AS avg_wind_speed,
        MAX(w.wind_peakgust_kmh) AS peak_wind_gust
    FROM prep_flights f
    JOIN prep_weather_daily w ON f.flight_date = w.date
    GROUP BY f.origin, f.flight_date
)
SELECT 
    fw.*,
    ap.city,
    ap.country,
    ap.name
FROM flight_weather fw
JOIN prep_airports ap ON fw.faa = ap.faa;