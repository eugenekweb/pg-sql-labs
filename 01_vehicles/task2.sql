-- task 2
SELECT v.maker, v.model, t.horsepower, t.engine_capacity, v.type
FROM vehicle v 
JOIN (
	SELECT model, horsepower, engine_capacity
	FROM car
	WHERE horsepower > 150
		AND engine_capacity < 3
		AND price < 35000
	UNION ALL
	SELECT model, horsepower, engine_capacity
	FROM motorcycle
	WHERE horsepower > 150
		AND engine_capacity < 1.5
		AND price < 20000
	UNION ALL
	SELECT model, NULL, NULL
	FROM bicycle
	WHERE gear_count > 18
		AND price < 4000
	) AS t USING(model)
ORDER BY t.horsepower DESC NULLS LAST;