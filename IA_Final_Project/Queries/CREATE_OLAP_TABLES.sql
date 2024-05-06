CREATE SCHEMA IF NOT EXISTS mission_green_dw;

DROP TABLE IF EXISTS mission_green_dw.date_dim;
CREATE TABLE IF NOT EXISTS mission_green_dw.date_dim (
	date_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date DATE,
    month INT,
    year INT,
    day INT
);

CREATE TABLE IF NOT EXISTS mission_green_dw.gas_dim (
	gas_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    aqs_parameter_code INT,
    aqs_parameter_desc VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS mission_green_dw.coliform_dim (
	coliform_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    label VARCHAR(15),
    code CHAR(2)
);

CREATE TABLE IF NOT EXISTS mission_green_dw.ecoli_dim (
	ecoli_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    label VARCHAR(15),
    code CHAR(2)
);


CREATE TABLE IF NOT EXISTS mission_green_dw.meetstandards_dim (
	ms_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    label VARCHAR(15),
    code CHAR(3)
);



CREATE TABLE IF NOT EXISTS mission_green_dw.location_dim (
	location_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    state VARCHAR(100),
    state_code INT,
    county VARCHAR(100),
    county_code INT,
    zipcode INT
);

DROP TABLE IF EXISTS mission_green_dw.air_water_fact;
CREATE TABLE mission_green_dw.air_water_fact (
  date_id int DEFAULT NULL,
  location_id int DEFAULT NULL,
  CO_Gas  float DEFAULT NULL,
  NO2_Gas  float DEFAULT NULL,
  Ozone_Gas  float DEFAULT NULL,
  PM10_Gas  float DEFAULT NULL,
  SO2_Gas  float DEFAULT NULL,
  PM2_Gas  float DEFAULT NULL,
  Max_AQI_Conc  float DEFAULT NULL,
  Gas_id int DEFAULT NULL,
  ecoli_id int DEFAULT NULL,
  coliform_id int DEFAULT NULL,
  ms_id int DEFAULT NULL,
  CONSTRAINT air_water_fact_ibfk_1 FOREIGN KEY (date_id) REFERENCES mission_green_dw.date_dim (date_id),
  CONSTRAINT air_water_fact_ibfk_2 FOREIGN KEY (location_id) REFERENCES mission_green_dw.location_dim (location_id),
  CONSTRAINT air_water_fact_ibfk_3 FOREIGN KEY (gas_id) REFERENCES mission_green_dw.gas_dim (gas_id),
  CONSTRAINT air_water_fact_ibfk_4 FOREIGN KEY (ecoli_id) REFERENCES mission_green_dw.ecoli_dim (ecoli_id),
  CONSTRAINT air_water_fact_ibfk_5 FOREIGN KEY (coliform_id) REFERENCES mission_green_dw.coliform_dim (coliform_id),
  CONSTRAINT air_water_fact_ibfk_6 FOREIGN KEY (ms_id) REFERENCES mission_green_dw.meetstandards_dim (ms_id)
);