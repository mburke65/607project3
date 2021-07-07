DROP TABLE IF EXISTS teaching;
DROP TABLE IF EXISTS algorithm;
DROP TABLE IF EXISTS method;
DROP TABLE IF EXISTS tool;

CREATE TABLE teaching (
  id INTEGER AUTO_INCREMENT PRIMARY KEY NOT NULL,
  ds_id INTEGER NOT NULL,
  category VARCHAR(100) NOT NULL,
  percent INTEGER NOT NULL
  );
  
LOAD DATA LOCAL INFILE 'C:\\Users\\Brian\\Desktop\\GradClasses\\Spring18\\607\\607project3\\tidied_csv\\learning_category.csv' 
INTO TABLE teaching
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS(ds_id, category, percent)
;


CREATE TABLE algorithm(
    id INTEGER AUTO_INCREMENT PRIMARY KEY NOT NULL,
    ds_id INTEGER NOT NULL,
    algorithm VARCHAR(255) NOT NULL
    );
    
LOAD DATA LOCAL INFILE 'C:\\Users\\Brian\\Desktop\\GradClasses\\Spring18\\607\\607project3\\tidied_csv\\algorithms.csv' 
INTO TABLE algorithm
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS(ds_id, algorithm)
;

CREATE TABLE method(
    id INTEGER AUTO_INCREMENT PRIMARY KEY NOT NULL,
    ds_id INTEGER NOT NULL,
    datasetsize VARCHAR(50) NOT NULL,
    method VARCHAR(255) NOT NULL,
    frequency VARCHAR(50)
    );
    
LOAD DATA LOCAL INFILE 'C:\\Users\\Brian\\Desktop\\GradClasses\\Spring18\\607\\607project3\\tidied_csv\\methods.csv' 
INTO TABLE method
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS(ds_id, datasetsize, method, @frequency)
SET 
frequency = nullif(@frequency,'NA')
;

CREATE TABLE tool(
    id INTEGER AUTO_INCREMENT PRIMARY KEY NOT NULL,
    ds_id INTEGER NOT NULL,
    tool_name VARCHAR(255) NOT NULL,
    frequency VARCHAR(255) NOT NULL
    );
    
LOAD DATA LOCAL INFILE 'C:\\Users\\Brian\\Desktop\\GradClasses\\Spring18\\607\\607project3\\tidied_csv\\tool_use.csv' 
INTO TABLE tool
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS(ds_id, tool_name, frequency)
;