-- task2
SELECT c.name, c.class, 
	AVG(r.position) avg_pos, 
	COUNT(r.race) race_count,
	cl.country
FROM results r
	JOIN cars c ON r.car = c.name
	JOIN classes cl USING(class)
GROUP BY c.name, cl.country
ORDER BY avg_pos, c.name
-- Возвращаем только одну строку с лучшей средней позицией
LIMIT 1;
	
	
