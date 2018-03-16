DROP TABLE IF EXISTS teaching;

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