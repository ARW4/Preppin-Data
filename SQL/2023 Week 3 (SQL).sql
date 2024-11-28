WITH CTE AS (
    SELECT 
    CASE 
    WHEN online_or_in_person = 1 THEN 'Online'
    WHEN online_or_in_person = 2 THEN 'In-Person'
    END as online_in_person
    ,DATE_PART('quarter',DATE(transaction_date,'dd/MM/yyyy HH24:MI:SS')) as quarter
    ,SUM(value) as total_value
    
FROM pd2023_wk01

WHERE SPLIT_PART(transaction_code,'-',1) = 'DSB'

GROUP BY 1,2
)

SELECT online_or_in_person
    ,REPLACE(T.quarter,'Q','')::int as quarter
    ,V.total_value
    ,target
    ,V.total_value - target as variance_from_target

FROM pd2023_wk03_targets as T

UNPIVOT(target FOR quarter IN (Q1,Q2,Q3,Q4))

INNER JOIN CTE AS V ON T.ONLINE_OR_IN_PERSON = V.online_in_person AND REPLACE(T.quarter,'Q','')::int = V.quarter
