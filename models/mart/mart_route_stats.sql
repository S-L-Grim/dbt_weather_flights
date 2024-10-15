WITH route_stats AS (
    SELECT 
        origin AS origin_faa,
        dest AS dest_faa,
        COUNT(flight_number) AS total_flights,
        COUNT(DISTINCT tail_number) AS unique_airplanes,
        COUNT(DISTINCT airline) AS unique_airlines,
        AVG(actual_elapsed_time) AS avg_elapsed_time,
        AVG(arr_delay) AS avg_arrival_delay,
        MAX(arr_delay) AS max_delay,
        MIN(arr_delay) AS min_delay,
        SUM(cancelled) AS total_cancelled,
        SUM(diverted) AS total_diverted
    FROM prep_flights
    GROUP BY origin, dest
)
SELECT 
    rs.*,
    origin_airports.city AS origin_city,
    origin_airports.country AS origin_country,
    origin_airports.name AS origin_name,
    dest_airports.city AS dest_city,
    dest_airports.country AS dest_country,
    dest_airports.name AS dest_name
FROM route_stats rs
JOIN prep_airports origin_airports ON rs.origin_faa = origin_airports.faa
JOIN prep_airports dest_airports ON rs.dest_faa = dest_airports.faa;