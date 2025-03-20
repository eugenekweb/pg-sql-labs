-- task5

WITH
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
	tac.race_count, cl.country,
	-- Общее количество гонок в классе
	SUM(tac.race_count) OVER (PARTITION BY tac.class) AS total_races,
	-- Количество машин с низкой позицией в классе
	COUNT(tac.class) OVER (PARTITION BY tac.class) AS low_pos_count
FROM tmp_avg4cars tac
JOIN classes cl USING(class) 
WHERE car_avg_pos > 3
ORDER BY low_pos_count DESC;
