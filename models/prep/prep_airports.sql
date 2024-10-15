WITH airports_reorder AS (
    SELECT faa,
           airport_name,
           country,
           region,  -- перемещаем region сразу после country
           city,
           latitude,
           longitude,
           elevation
    FROM {{ref('staging_airports')}}
)
SELECT * FROM airports_reorder;