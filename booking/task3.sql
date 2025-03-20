-- task 3

WITH 
-- 1
tmp_hotel_categorising AS (
    SELECT h.id_hotel, h.name AS hotel_name,
        AVG(r.price) AS avg_price,
        CASE 
            WHEN AVG(r.price) < 175 THEN 'Дешевый'
            WHEN AVG(r.price) BETWEEN 175 AND 300 THEN 'Средний'
            ELSE 'Дорогой'
        END AS hotel_category
    FROM hotel h
	JOIN room r USING(id_hotel)
    GROUP BY h.id_hotel
),
tmp_customer_preferences AS (
    SELECT c.id_customer, c.name,
        -- 2
        CASE 
            WHEN MAX(CASE WHEN hotel_category = 'Дорогой' THEN 1 ELSE 0 END) = 1 THEN 'Дорогой'
            WHEN MAX(CASE WHEN hotel_category = 'Средний' THEN 1 ELSE 0 END) = 1 THEN 'Средний'
            ELSE 'Дешевый'
        END AS preferred_hotel_type,
        -- 3
        STRING_AGG(DISTINCT h.name, ', ') AS visited_hotels
    FROM customer c 
	JOIN booking b USING(id_customer)
	JOIN room r USING(id_room)
	JOIN hotel h USING(id_hotel)
	JOIN tmp_hotel_categorising thc USING(id_hotel)
    GROUP BY c.id_customer
)
SELECT * FROM tmp_customer_preferences 
-- 4
ORDER BY 
    CASE 
        WHEN preferred_hotel_type = 'Дешевый' THEN 1
        WHEN preferred_hotel_type = 'Средний' THEN 2
        WHEN preferred_hotel_type = 'Дорогой' THEN 3
    END;
