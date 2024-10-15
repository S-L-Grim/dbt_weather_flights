-- Collecting daily flight statistics for each airport
WITH daily_flight_stats AS (
    SELECT 
        origin AS faa,
        flight_date, -- assuming there is a flight_date field in prep_flights

        -- Unique number of departure connections
        COUNT(DISTINCT origin) AS unique_departures,

        -- Unique number of arrival connections
        COUNT(DISTINCT dest) AS unique_arrivals,

        -- Total planned flights (departures + arrivals)
        COUNT(sched_dep_time) AS total_planned_flights,

        -- Total cancelled flights (departures + arrivals)
        SUM(cancelled) AS total_cancelled_flights,

        -- Total diverted flights (departures + arrivals)
        SUM(diverted) AS total_diverted_flights,

        -- Total actually occurred flights (departures + arrivals)
        COUNT(arr_time) AS total_occurred_flights,

        -- Optional: Unique airplanes on average (by tail number)
        COUNT(DISTINCT tail_number) AS unique_airplanes,

        -- Optional: Unique airlines on average
        COUNT(DISTINCT airline) AS unique_airlines
    FROM prep_flights
    GROUP BY origin, flight_date
),

-- Collecting weather data for each airport daily
daily_weather AS (
    SELECT 
        faa, 
        weather_date, -- assuming there is a weather_date field in prep_weather
        MIN(temp_min) AS daily_min_temperature,
        MAX(temp_max) AS daily_max_temperature,
        SUM(precipitation) AS daily_precipitation,
        SUM(snowfall) AS daily_snowfall,
        AVG(wind_direction) AS daily_avg_wind_direction,
        AVG(wind_speed) AS daily_avg_wind_speed,
        MAX(peak_wind_gust) AS daily_max_wind_gust
    FROM prep_weather
    GROUP BY faa, weather_date
),

-- Adding city, country, and name of the airport
airport_info AS (
    SELECT 
        faa,
        city,
        country,
        name
    FROM prep_airports
)

-- Combining flight stats with weather data and airport information
SELECT 
    dfs.faa,
    ai.city,
    ai.country,
    ai.name,
    dfs.flight_date,

    -- Flight statistics
    dfs.unique_departures,
    dfs.unique_arrivals,
    dfs.total_planned_flights,
    dfs.total_cancelled_flights,
    dfs.total_diverted_flights,
    dfs.total_occurred_flights,
    dfs.unique_airplanes,  -- Optional
    dfs.unique_airlines,   -- Optional

    -- Weather data
    dw.daily_min_temperature,
    dw.daily_max_temperature,
    dw.daily_precipitation,
    dw.daily_snowfall,
    dw.daily_avg_wind_direction,
    dw.daily_avg_wind_speed,
    dw.daily_max_wind_gust

FROM daily_flight_stats dfs
LEFT JOIN daily_weather dw
    ON dfs.faa = dw.faa
    AND dfs.flight_date = dw.weather_date
LEFT JOIN airport_info ai
    ON dfs.faa = ai.faa
ORDER BY dfs.flight_date, dfs.faa;