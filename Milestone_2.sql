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
  
  
  
  
