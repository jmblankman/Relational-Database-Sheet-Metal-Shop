CREATE TABLE IF NOT EXISTS  `part` (
  `serial_number` int(12) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `model_number` varchar(30)  NOT NULL,
  `name` varchar(20)  NOT NULL,
  `description` TEXT NOT NULL,
  `price` DOUBLE(20,2) NOT NULL,
  `cost`  DOUBLE(20,2) NOT NULL
 );
 
 CREATE TABLE IF NOT EXISTS  `vehicle` (
  `license_plate` varchar(20)  NOT NULL PRIMARY KEY,
  `model` varchar(30)  NOT NULL,
  `manufacturer` varchar(30)  NOT NULL,
  `year` int(4) NOT NULL
 );

 CREATE TABLE IF NOT EXISTS  `Tool` (
  `tool_serial_number` int(12) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` varchar(30)  NOT NULL,
  `description` varchar(30)  NOT NULL,
  `price`  DOUBLE(20,2) NOT NULL
 );
 
 CREATE TABLE  IF NOT EXISTS `customer` (
  `customer_id` int(12) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `first_name` varchar(25) NOT NULL,
  `last_name` varchar(25) NOT NULL,
  `street` varchar(30)  NOT NULL,
  `city` varchar(20)  NOT NULL,
  `state` char(2)  NOT NULL,
  `zipcode` char(6)  NOT NULL,
  `phone` BIGINT  NOT NULL,
  `business` varchar(30) NULL
);

CREATE TABLE  IF NOT EXISTS `worker` (
  `employee_id` int(12) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `first_name` varchar(25) NOT NULL,
  `last_name` varchar(25) NOT NULL,
  `street` varchar(30)  NOT NULL,
  `city` varchar(20)  NOT NULL,
  `state` char(2)  NOT NULL,
  `zipcode` char(6)  NOT NULL,
  `phone` BIGINT  NOT NULL,
  `tool_serial_number` int(12) NOT NULL,
  `license_plate` varchar(20)  NOT NULL,
  CONSTRAINT `worker_fk1` FOREIGN KEY (`tool_serial_number`) REFERENCES `tool` (`tool_serial_number`)
  ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `worker_fk2` FOREIGN KEY (`license_plate`) REFERENCES `vehicle` (`license_plate`)
  ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS  `job` (
  `job_id` int(12) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `job_date` DATETIME NOT NULL,
  `street` varchar(30)  NOT NULL,
  `city` varchar(20)  NOT NULL,
  `state` char(2)  NOT NULL,
  `zipcode` char(6)  NOT NULL,
  `description` TEXT NOT NULL,
  `labor` DOUBLE(20,2) NOT NULL,
  `price`  DOUBLE(20,2) NOT NULL,
  `contact` int(12) NULL,
  `serial_number` int(12) NOT NULL,
  `customer_id` int(12) NOT NULL,
  CONSTRAINT `job_fk1` FOREIGN KEY (`serial_number`) REFERENCES `part` (`serial_number`)
  ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `job_fk2` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`)
  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS  `contract` (
  `employee_id` int(12) NOT NULL,
  `job_id` int(12) NOT NULL,
  PRIMARY KEY (`employee_id`,`job_id`),
  CONSTRAINT `contract_fk1` FOREIGN KEY (`employee_id`) REFERENCES `worker` (`employee_id`)
  ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `contract_fk2` FOREIGN KEY (`job_id`) REFERENCES `job` (`job_id`)
  ON DELETE CASCADE ON UPDATE CASCADE
  
  );
  
#Query 1  
  SELECT*
  FROM contract
  
#Query 2
  SELECT*
  From `contract`
  WHERE `job_id` IN (SELECT`job_id`
		        FROM `job`
  		        WHERE `job_date` > '06-01-2020')
#Query 3
  SELECT*
  From `contract`
  WHERE `job_id` IN (SELECT`job_id`
					FROM `job`
  					WHERE `job_date` > '06-01-2020'
					AND customer_id IN (SELECT `customer_id`
									   FROM `customer`
									   WHERE `business` = 'entertainment')
																		);
#Query 4	
SELECT*
FROM `contract`
NATURAL JOIN `worker`;

#Query 5
SELECT w.`state`, w.`employee_id`, j.`job_id`,c.`customer_id`, c.`state`
FROM `worker`w
INNER JOIN `contract` con ON w.`employee_id` = con.`employee_id`	
INNER JOIN `job` j ON con.`job_id` = j.`job_id`
INNER JOIN `customer` c ON j.`customer_id` = c.`customer_id`;

## View 1

CREATE OR REPLACE VIEW `customer_view` AS
SELECT j.job_id, j.job_date, j.street, j.city, j.state, j.zipcode, CONCAT(w.first_name, ' ', w.last_name) AS `worker_name`, w.phone, j.description, p.name AS `part_name`, p.price AS `part_price`, c.labor_hour AS `labor_price`, (c.labor_hour + p.price) AS `total_price`, j.contact
FROM job j
INNER JOIN part p ON p.serial_number = j.serial_number
INNER JOIN contract c ON c.job_id = j.job_id
INNER JOIN worker w ON w.employee_id = c.employee_id;

## View 2

CREATE OR REPLACE VIEW `worker_view` AS
SELECT j.job_id, j.job_date, CONCAT(c.first_name, ' ', c.last_name) AS `customer_name`, j.contact, j.description AS `job_description`, j.street, j.city, j.state, j.zipcode, p.name AS `part_name`, p.description AS `part_description`, p.model_number
FROM job j
INNER JOIN customer c ON c.customer_id = j.customer_id
INNER JOIN part p ON P.serial_number = j.serial_number;

## View 3

CREATE OR REPLACE VIEW `contact_view` AS
SELECT j.job_id, j.job_date, CONCAT(w.first_name, ' ', w.last_name) AS `worker_name`, w.phone AS `worker_phone`, j.description, j.street, j.city, j.state, j.zipcode
FROM job j
INNER JOIN part p ON p.serial_number = j.serial_number
INNER JOIN contract c ON c.job_id = j.job_id
INNER JOIN worker w ON w.employee_id = c.employee_id;

## View 4 

CREATE OR REPLACE VIEW `job_report_view` AS
SELECT j.job_id, CONCAT(cu.first_name, ' ', cu.last_name) AS `customer_name`, cu.business, j.description, CONCAT(w.first_name, w.last_name) AS `worker_name`, p.name AS `part_name`, p.model_number, p.serial_number, (co.labor_hour + p.price) AS `total_price`, (w.wage + p.cost) AS `total_cost`, ((co.labor_hour + p.price) - (w.wage + p.cost)) AS `profit`, j.street, j.city, j.state, j.zipcode
FROM job j
INNER JOIN customer cu ON cu.customer_id = j.customer_id
INNER JOIN part p ON p.serial_number = j.serial_number
INNER JOIN contract co ON co.job_id = j.job_id
INNER JOIN worker w ON w.employee_id = co.employee_id;

#Permission 1 - Worker

GRANT SELECT, UPDATE
ON `job`, `contract` 
TO "employee_id"


## Permission 2 - Customer

GRANT SELECT 
ON `job`
TO 'customer_id'

## Permission 3 - Administrator 

GRANT ALL 
ON *
TO 'employee_id'
