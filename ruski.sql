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

-- Find out the models and prices for all the products (of any type) produced by maker B. 

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

-- Find out the makers that sale PCs but not laptops. 

SELECT
	* 
FROM 
	product 
INNER JOIN pc 
	ON product.model = pc.model
LEFT JOIN laptop
	ON product.model = laptop.model;

-- Find the printers having the highest price. Result set: model, price. 

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

-- Find out the average speed of PCs. 

SELECT 
	AVG(speed) 
FROM 
	pc;

-- Find all the makers who have all their models of PC type in the PC table 

-- Find out the average speed of the PCs produced by maker A. 

-- For Product table, receive result set in the form of a table with columns: 
-- maker, pc, laptop, and printer.For each maker, this table must include "yes" if a maker has products of corresponding type or "no" otherwise.
-- In the first case (yes), specify in brackets (without spaces) the quantity of available distinct models of 
-- corresponding type (i.e. being in PC, Laptop, and Printer tables). 

-- Find the hard drive sizes that are equal among two or more PCs. Result set: hd. 

-- Find the pairs of PC models having similar speeds and RAM. 
-- As a result, each resulting pair is shown only once, i.e. (i, j) but not (j, i). 
-- Result set: model with high number, model with low number, speed, and RAM. 

-- Find the laptops having speeds less than all PCs. Result set: type, model, speed. 

-- Find the makers of the cheapest color printers. Result set: maker, price. 

-- Find the makers producing at least three distinct models of PCs. Result set: maker, number of models. 

-- Find the makers producing at least both a pc having speed not less than 750 MHz and a laptop having speed not less than 750 MHz. Result set: Maker 

-- Find the model number of the product (PC, laptop, or printer) with the highest price.Result set: model 

-- Find the printer makers which also produce PCs with the lowest RAM and the highest-speed processor among PCs with the lowest RAM. Result set: maker. 

-- Define the average price of the PCs and laptops produced by maker A.Result set: single total price. 

-- Define the average size of the PC hard drive for each maker that also produces printers.Result set: maker, average capacity of HD. 