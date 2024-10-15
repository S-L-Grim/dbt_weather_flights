-- Creating a stats table for each route (origin to destination) over all time

WITH route_stats AS (
    SELECT 
        origin AS origin_airport_code,
        dest AS destination_airport_code,
        
        -- Total number of flights on this route
        COUNT(*) AS total_flights,

        -- Unique number of airplanes (using tail_number)
        COUNT(DISTINCT tail_number) AS unique_airplanes,

        -- Unique number of airlines (using airline code)
        COUNT(DISTINCT airline) AS unique_airlines,

        -- Average actual elapsed time (difference between arr_time and dep_time)
        AVG(arr_time - dep_time) AS avg_elapsed_time,

        -- Average delay on arrival (arr_delay)
        AVG(arr_delay) AS avg_arrival_delay,

        -- Maximum delay on arrival
        MAX(arr_delay) AS max_arrival_delay,

        -- Minimum delay on arrival
        MIN(arr_delay) AS min_arrival_delay,

        -- Total number of cancelled flights
        SUM(cancelled) AS total_cancelled,

        -- Total number of diverted flights
        SUM(diverted) AS total_diverted

    FROM prep_flights
    GROUP BY origin, dest
),

-- Adding city, country, and name for both origin and destination airports
origin_info AS (
    SELECT 
        faa AS origin_airport_code,
        city AS origin_city,
        country AS origin_country,
        name AS origin_airport_name
    FROM prep_airports
),

destination_info AS (
    SELECT 
        faa AS destination_airport_code,
        city AS destination_city,
        country AS destination_country,
        name AS destination_airport_name
    FROM prep_airports
)

-- Joining route stats with airport info for both origin and destination
SELECT 
    rs.origin_airport_code,
    oi.origin_city,
    oi.origin_country,
    oi.origin_airport_name,

    rs.destination_airport_code,
    di.destination_city,
    di.destination_country,
    di.destination_airport_name,

    rs.total_flights,
    rs.unique_airplanes,
    rs.unique_airlines,
    rs.avg_elapsed_time,
    rs.avg_arrival_delay,
    rs.max_arrival_delay,
    rs.min_arrival_delay,
    rs.total_cancelled,
    rs.total_diverted

FROM route_stats rs
LEFT JOIN origin_info oi
ON rs.origin_airport_code = oi.origin_airport_code

LEFT JOIN destination_info di
ON rs.destination_airport_code = di.destination_airport_code

ORDER BY rs.origin_airport_code, rs.destination_airport_code