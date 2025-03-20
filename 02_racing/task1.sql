-- task 1
SELECT all_cars.name, all_cars.class, all_cars.avg_pos, all_cars.race_count
FROM (
	SELECT c.name, c.class, 
		AVG(r.position) avg_pos, 
		COUNT(r.race) race_count,
		RANK() OVER (PARTITION BY c.class ORDER BY AVG(r.position)) AS best
	FROM results r
	JOIN cars c ON r.car = c.name 
	GROUP BY c.name
	ORDER BY c.name
) all_cars
WHERE all_cars.best = 1
ORDER BY all_cars.avg_pos;
