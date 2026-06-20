USE medicaredb


-- Q1Total Discharges

SELECT COUNT(*) AS Total_Discharges
FROM vw_admissiondata
WHERE OUTCOME = 'DISCHARGE';



-- Q2 Average Daily Discharge Rate
-- Formula:
-- (Total Discharges / Total Length of Stay) * 100

SELECT
    ROUND(
        SUM(CASE
                WHEN OUTCOME = 'DISCHARGE' THEN 1
                ELSE 0
            END) * 100.0
        / SUM(`DURATION OF STAY`),
        2
    ) AS Avg_Daily_Discharge_Rate
FROM vw_admissiondata;
-- Avoiding Subquery
    SELECT
    ROUND(
        SUM(CASE
                WHEN OUTCOME = 'DISCHARGE' THEN 1
                ELSE 0
            END) * 100.0
        / SUM(`DURATION OF STAY`),
        2
    ) AS Avg_Daily_Discharge_Rate
FROM vw_admissiondata;

-- Q3 Average Length Of Stay(ALOS)
-- it is total length of stay devide by Total Discharges
SELECT
    ROUND(
        SUM(`DURATION OF STAY`) /
        COUNT(CASE
                 WHEN OUTCOME = 'DISCHARGE'
                 THEN 1
              END),
        0
    ) AS Avg_Length_Of_Stay
FROM vw_admissiondata;

-- Q4 Distribution of Discharges by Age Group
-- < 16 Paediatric
-- 16 < 65 Adult
-- >= 65 Senior Citizen
  SELECT

    CASE

        WHEN AGE < 16 THEN 'Paediatric'

        WHEN AGE < 65 THEN 'Adult'

        WHEN AGE >= 65 THEN 'Senior Citizen'

        ELSE 'Unknown'

    END AS Age_Group,

    COUNT(*) AS Age_Distribution

FROM vw_admissiondata

WHERE OUTCOME = 'DISCHARGE'

GROUP BY

    CASE

        WHEN AGE < 16 THEN 'Paediatric'

        WHEN AGE < 65 THEN 'Adult'

        WHEN AGE >= 65 THEN 'Senior Citizen'

ELSE 'Unknown'

END
ORDER BY Age_Distribution DESC ;


-- Q5 Distribution of discharge by gender
SELECT
    GENDER,
    COUNT(*) AS Gender_Distribution

FROM vw_admissiondata

WHERE OUTCOME = 'DISCHARGE'

GROUP BY GENDER

ORDER BY COUNT(*) DESC ;

-- Q6 Distribution of discharge by  Day of the week

      
SELECT *
FROM vw_admissiondata
WHERE COALESCE(
        STR_TO_DATE(`D.O.D`, '%d/%m/%Y'),
        STR_TO_DATE(`D.O.D`, '%m/%d/%Y')
      ) IS NULL;
      
      SELECT
    DAYNAME(
        COALESCE(
            STR_TO_DATE(`D.O.D`, '%d/%m/%Y'),
            STR_TO_DATE(`D.O.D`, '%m/%d/%Y')
        )
    ) AS Day_Of_Week,

    COUNT(*) AS Day_Distribution

FROM vw_admissiondata

WHERE OUTCOME = 'DISCHARGE'
  AND COALESCE(
        STR_TO_DATE(`D.O.D`, '%d/%m/%Y'),
        STR_TO_DATE(`D.O.D`, '%m/%d/%Y')
      ) IS NOT NULL

GROUP BY Day_Of_Week

ORDER BY Day_Distribution DESC;