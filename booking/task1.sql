-- task 1

WITH 
tmp_all_bookings AS (
	SELECT c.name, c.email, c.phone,
			count(b.id_booking) AS total_bookings,
--			concat_ws(', ', array_agg(DISTINCT h.name)) hotels,
	    	STRING_AGG(DISTINCT h.name, ', ') AS hotels,
		    AVG(b.check_out_date - b.check_in_date) AS avg_staying,
	        COUNT(DISTINCT h.id_hotel) AS unique_hotels
		FROM customer c 
		JOIN booking b USING(id_customer)
		JOIN room r USING(id_room)
		JOIN hotel h USING(id_hotel)
	GROUP BY c.id_customer
),
tmp_mult_visitors AS (
	SELECT *
	FROM tmp_all_bookings 
	WHERE total_bookings > 2 AND unique_hotels > 1
)
SELECT tmv.name, tmv.email, tmv.phone,
		tmv.total_bookings, tmv.hotels
FROM tmp_mult_visitors tmv
ORDER BY tmv.total_bookings DESC;