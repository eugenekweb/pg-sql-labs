-- task 1

WITH 
tmp_all_bookings AS (
	SELECT c.name, c.email, c.phone,
			count(b.id_booking) AS total_bookings,
			-- Именно CONCAT здесь плохо использовать, значение динамическое
			-- Можно было бы через объединение массива в строку внутри CONCAT, но это костыль
--			concat_ws(', ', array_agg(DISTINCT h.name)) hotels,
	    	-- Список уникальных отелей через запятую
			STRING_AGG(DISTINCT h.name, ', ') AS hotels,
			-- Средняя продолжительность пребывания
		    AVG(b.check_out_date - b.check_in_date) AS avg_staying,
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
	-- Выбираем клиентов с более чем двумя бронированиями в разных отелях
	WHERE total_bookings > 2 AND unique_hotels > 1
)
SELECT tmv.name, tmv.email, tmv.phone,
		tmv.total_bookings, tmv.hotels
FROM tmp_mult_visitors tmv
-- Сортируем по убыванию общего количества бронирований
ORDER BY tmv.total_bookings DESC;
