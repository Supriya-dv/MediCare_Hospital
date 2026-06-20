USE medicaredb ;

-- =====================================================
-- Create a Clean View for Analysis
-- Purpose: Remove duplicate patient records
-- =====================================================
CREATE OR REPLACE VIEW vw_AdmissionData AS

WITH CleanData AS (

    -- Identify duplicate records
    SELECT *,

           ROW_NUMBER() OVER (

               -- Group same patient admission records
               PARTITION BY `MRD No.`, `D.O.A`, `D.O.D`

               -- Sort inside each group
               ORDER BY `MRD No.`

           ) AS Dup_No

    FROM medicare_data
)

-- Keep only unique records
SELECT *
FROM CleanData

-- First occurrence only
WHERE Dup_No = 1

-- Remove null patient IDs
AND `MRD No.` IS NOT NULL;

