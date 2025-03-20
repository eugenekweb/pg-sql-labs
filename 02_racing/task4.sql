-- task4

WITH
tmp_avg4class AS 
	(SELECT 
        c.class,
        AVG(r.position) AS class_avg_pos
    FROM results r
    JOIN cars c ON c.name = r.car
    GROUP BY c.class),
tmp_avg4cars AS 
    (SELECT c.name, c.class,
		-- Средняя позиция для каждой машины
		AVG(r.position) AS car_avg_pos,
		-- Количество гонок для каждой машины
		COUNT(r.race) AS race_count
	FROM results r
	JOIN cars c ON r.car = c.name
	GROUP BY c.name)
SELECT tac.name, tac.class,
	tac.car_avg_pos,
	tac.race_count, cl.country
FROM tmp_avg4cars tac
JOIN tmp_avg4class tacl USING(class)
JOIN classes cl USING(class)
-- Выбираем только машины, чья средняя позиция лучше средней позиции класса
WHERE car_avg_pos < class_avg_pos 
ORDER BY tac.class, tac.car_avg_pos, tac.name;
