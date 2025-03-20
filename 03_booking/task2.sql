-- task 2

WITH 
tmp_all_bookings AS (
	SELECT c.id_customer, c.name,
			count(b.id_booking) AS total_bookings,
			-- Общие расходы на бронирования
	    	SUM(r.price * (b.check_out_date - b.check_in_date)) AS total_spent,
	        -- Количество уникальных отелей
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
	-- Клиенты с более чем двумя бронированиями в разных отелях
	WHERE total_bookings > 2 AND unique_hotels > 1
),
tmp_richest_visitors AS (
	SELECT *
	FROM tmp_all_bookings 
	-- Клиенты, потратившие более 500 долларов
	WHERE total_spent > 500
)
SELECT tmv.id_customer, tmv.name, tmv.total_bookings,
        tmv.total_spent, tmv.unique_hotels
FROM tmp_mult_visitors tmv
-- Объединяем клиентов из двух групп по id_customer
JOIN tmp_richest_visitors trv USING(id_customer)
-- Сортируем по общим расходам
ORDER BY tmv.total_spent;
