USE ruskidb;

-- SCHEMA
-- +--------------------+ 		      +--------------------+
-- | product            |			  |	laptops			   |
-- +--------------------+ 			  +--------------------+
-- | maker varchar(10)  |			  | code int  		   |
-- | model varchar(50)  |	======>	  | model varchar(50)  |
-- | type varchar(50    |	||		  |	speed smallint	   |
-- +--------------------+	||		  | ram smallint	   |
-- | pc                 |	||		  |	hd real            |
-- +--------------------+	||	      |	price money        |
-- | code int           |	||	      | screen tinyint     |
-- | model varchar(50)  | <=||		  +--------------------+
-- | speed smallint     |	||
-- | ram smallint       |	||
-- | hd real            |	||
-- | cd varhcar(10)		|	||		+-------------------+
-- | price money        |	||		| printer			|
-- +--------------------+	||		+-------------------+
-- 							||		| code int     		|
-- 							====>	| model varchar(50) |
-- 									| color char(1)     |
-- 									| type varhcar(10)	|
-- 									| price money       |
-- 									+-------------------+


-- 1) Find the model number, speed and hard drive capacity for all the PCs with prices below $500. 
-- Result set: model, speed, hd. 

SELECT
	model,
	speed,
	hd
FROM
	pc
WHERE
	price < 500;

-- 2) Find the printer makers

SELECT
	maker
FROM
	Product
WHERE model in (
	SELECT model
FROM Printer
    );

-- 3) Find the model number, RAM and screen size of the laptops with prices over $1000. 

SELECT
	model,
	ram,
	screen
FROM
	laptop
WHERE price > 1000;

--  4) Find the model number, speed and hard drive capacity of the PCs having 
-- 12x CD and prices less than $600 or having 24x CD and prices less than $600. 

SELECT
	model,
	hd
FROM
	pc
WHERE (cd = '12' AND price > 600) OR (cd = '24' AND prices < 600);

-- 5) For each maker producing laptops with a hard drive capacity of 10 Gb or higher, find the speed of such laptops. 
-- Result set: maker, speed. 

SELECT
	product.maker, Laptop.speed
FROM
	product, laptop
WHERE laptop.hd >= 10;

-- 6) Find out the models and prices for all the products (of any type) produced by maker B. 

SELECT
	*
FROM
	product
	INNER JOIN laptops
		ON product.model = laptop.model
	INNER JOIN pc
		ON	product.model = pc.model
	INNER JOIN printer
		ON product.model = printer.model
WHERE product.maker = 'B';

-- 7) Find out the makers that sale PCs but not laptops. 

SELECT
	* 
FROM 
	product 
INNER JOIN pc 
	ON product.model = pc.model
LEFT JOIN laptop
	ON product.model = laptop.model;

-- 8) Find the printers having the highest price. Result set: model, price. 

SELECT 
	product.model, 
	printer.price
FROM 
	product, 
	printer
INNER JOIN 
	printer
ON 
	product.model = printer.model
ORDER BY 
	price DESC;

-- 9) Find out the average speed of PCs. 

SELECT 
	AVG(speed) 
FROM 
	pc;

-- 10) Find all the makers who have all their models of PC type in the PC table 

SELECT 
	maker
FROM
	product
WHERE product.type = 'pc';

-- 11) Find out the average speed of the PCs produced by maker A. 

SELECT
	AVG(speed)
FROM pc
	WHERE maker IN (
		SELECT maker
		FROM product
		WHERE maker = 'A' 
	);

-- 12) For Product table, receive result set in the form of a table with columns: 
-- maker, pc, laptop, and printer.For each maker, this table must include "yes" if a maker has products of corresponding type or "no" otherwise.
-- In the first case (yes), specify in brackets (without spaces) the quantity of available distinct models of 
-- corresponding type (i.e. being in PC, Laptop, and Printer tables). 



-- 13) Find the hard drive sizes that are equal among two or more PCs. Result set: hd. 

SELECT distinct 
	t.hd
FROM 
	PC t
WHERE EXISTS
	(SELECT 
		*
	FROM
		PC
	WHERE pc.hd = t.hd AND pc.model <> t.model
);


-- 14) Find the pairs of PC models having similar speeds and RAM. 
-- As a result, each resulting pair is shown only once, i.e. (i, j) but not (j, i). 
-- Result set: model with high number, model with low number, speed, and RAM. 

-- 15) Find the laptops having speeds less than all PCs. Result set: type, model, speed. 

SELECT
	type,
	model,
	speed,
FROM
	product, pc
WHERE product.type = 'laptop' AND laptop.speed < min(pc.speed);

-- 16) Find the makers of the cheapest color printers. Result set: maker, price. 

SELECT
	Product.maker, Printer.price
FROM
	Product, Printer
WHERE Printer.colour = 'y'
ORDER BY Printer.price ASC
LIMIT 1;


-- 17) Find the makers producing at least three distinct models of PCs. 
-- Result set: maker, number of models. 

SELECT
	Product.maker, PC.model
FROM
	Product, PC
WHERE
	Product.model = PC.model;

-- 18) Find the makers producing at least both a pc having speed not less than 750 MHz and a laptop having speed not less than 750 MHz. 
-- Result set: Maker 

SELECT distinct
	maker
FROM
	products
WHERE model in (
	SELECT
		speed
	FROM
		pc
	WHERE speed > 750
	UNION ALL
	SELECT
		speed
	FROM
		laptops
	WHERE speed > 750
);

-- 19) Find the model number of the product (PC, laptop, or printer) with the highest price.
-- Result set: model 

SELECT
	model
FROM (
	SELECT 
		model, 
		price
		WHERE 
			price = (SELECT max(price) FROM pc)
	UNION
	SELECT
		model,
		price
	WHERE
		price = (SELECT max(price) FROM laptop)
	UNION
	SELECT
		model,
		price
	WHERE
		price = (SELECT max(price) FROM printer);
);	



-- 20) Find the printer makers which also produce PCs with the lowest RAM and the highest-speed processor among PCs with the lowest RAM. 
-- Result set: maker. 

SELECT
	maker
FROM
	products
WHERE maker IN (
	SELECT 
		* 
	FROM
		pc
	WHERE ram = min(ram) AND cpu = max(cpu)
);

-- 21) Define the average price of the PCs and laptops produced by maker A.
-- Result set: single total price. 

SELECT 
	AVG(price) 
FROM 
	pc,
	laptop
WHERE 
	model in (
		SELECT 
			* 
		from 
			product
		WHERE product.maker = 'A'
	);

-- 22) Define the average size of the PC hard drive for each maker that also produces printers.
-- Result set: maker, average capacity of HD. 

SELECT Result.maker, avg(pc.hd)
FROM (SELECT pc.hd, Product.maker
	  FROM PC INNER JOIN
	  	Product ON PC.model = product.model
		WHERE Product.maker IN (
			SELECT 
				Product1.maker 
			FROM 
				product product1
			INNER JOIN Printer
			ON Product1.model = printer.model
			GROUP BY Product1.maker
		) AS result
	)
GROUP BY result.maker;