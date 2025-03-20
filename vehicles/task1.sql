-- task 1
SELECT v.maker, m.model 
FROM motorcycle m 
	JOIN vehicle v USING(model)
WHERE m.horsepower > 150
	AND m.price < 20000
	AND m.type = 'Sport'
ORDER BY m.horsepower DESC;