USE mission_green;

INSERT INTO mission_green_dw.date_dim(date, month, year, day)
SELECT a.date, 
    YEAR(a.date) AS year,
    MONTH(a.date) AS month,
    DAY(a.date) AS day
FROM (SELECT DISTINCT `DATE` as date FROM Air_Quality_Data ORDER BY `DATE`) as a;

INSERT INTO mission_green_dw.gas_dim(aqs_parameter_code, aqs_parameter_desc)
SELECT DISTINCT aqs_parameter_code, aqs_parameter_desc FROM Air_Quality_Data;

INSERT INTO mission_green_dw.coliform_dim(code, label)
SELECT 
  DISTINCT COALESCE(coliform, 'NA') AS code,
  CASE COALESCE(coliform, 'NA')
    WHEN 'A' THEN 'Absent'
    WHEN 'P' THEN 'Present'
    ELSE 'Not Available'
  END AS label
FROM mission_green.Drinking_Water_Quality_Data;


INSERT INTO mission_green_dw.ecoli_dim(code, label)
SELECT 
  DISTINCT COALESCE(ecoli, 'NA') AS code,
  CASE COALESCE(ecoli, 'NA')
    WHEN 'A' THEN 'Absent'
    WHEN 'P' THEN 'Present'
    ELSE 'Not Available'
  END AS label
FROM mission_green.Drinking_Water_Quality_Data;

INSERT INTO mission_green_dw.meetstandards_dim(code, label)
SELECT 
  DISTINCT COALESCE(meet_standards, 'NA') AS code,
  CASE COALESCE(meet_standards, 'NA')
    WHEN 'Y' THEN 'Yes'
    WHEN 'N' THEN 'No'
    ELSE 'Not Available'
  END AS label
FROM mission_green.Drinking_Water_Quality_Data;

INSERT INTO mission_green_dw.location_dim(state_code, state, county_code, county, zipcode)
WITH air_quality_filtered AS (
    SELECT DISTINCT state_code, state, county_code, county, zipcode
    FROM Air_Quality_Data
    WHERE zipcode IS NOT NULL
),
drinking_water_filtered AS (
    SELECT DISTINCT zipcode
    FROM Drinking_Water_Quality_Data
    WHERE zipcode IS NOT NULL
)
SELECT DISTINCT
    A.state_code,
    A.state,
    A.county_code,
    A.county,
    D.zipcode
FROM 
    air_quality_filtered AS A
JOIN 
    drinking_water_filtered AS D
ON 
    A.zipcode = D.zipcode;


INSERT INTO mission_green_dw.air_water_fact(date_id, location_id, gas_id, ecoli_id, coliform_id, aqi_value, gases_concentration)
SELECT
  DD.date_id,
  LD.location_id,
  GD.gas_id,
  ED.ecoli_id,
  CD.coliform_id,
  A.daily_aqi_value,
  A.gases_concentration
FROM mission_green.Air_Quality_Data AS A
LEFT JOIN mission_green.Drinking_Water_Quality_Data AS DW ON A.zipcode = DW.zipcode
JOIN mission_green_dw.date_dim DD ON A.DATE = DD.date
JOIN mission_green_dw.location_dim LD ON A.zipcode = LD.zipcode AND DW.zipcode = LD.zipcode  
JOIN mission_green_dw.gas_dim GD ON A.aqs_parameter_code = GD.aqs_parameter_code  
JOIN mission_green_dw.ecoli_dim ED ON DW.ecoli = ED.code  
JOIN mission_green_dw.coliform_dim CD ON DW.coliform = CD.code;
