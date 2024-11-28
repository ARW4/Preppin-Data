WITH LONG_TABLE AS (

SELECT CUSTOMER_ID
    ,value
    ,split_part(Categories,'_',1) as device
    ,TRIM(REPLACE(split_part(Categories,'__',2),'_',' ')) as Category
    
FROM PD2023_WK06_DSB_CUSTOMER_SURVEY

UNPIVOT ( Value
    FOR Categories 
    IN (MOBILE_APP___EASE_OF_USE, MOBILE_APP___EASE_OF_ACCESS, MOBILE_APP___NAVIGATION, MOBILE_APP___LIKELIHOOD_TO_RECOMMEND, MOBILE_APP___OVERALL_RATING, ONLINE_INTERFACE___EASE_OF_USE, ONLINE_INTERFACE___EASE_OF_ACCESS, ONLINE_INTERFACE___NAVIGATION, ONLINE_INTERFACE___LIKELIHOOD_TO_RECOMMEND, ONLINE_INTERFACE___OVERALL_RATING)
    ) 
), 
Preference_Table as (
Select Customer_ID
    ,Round(AVG("'MOBILE'"),2) as Mobile
    ,Round(AVG("'ONLINE'"),2) as Online
    ,mobile - online as Difference
    ,CASE 
        WHEN Difference > -1 and Difference < 1 THEN 'Nuetral'
        WHEN Difference >= 2 THEN 'Super Mobile Fan'
        WHEN Difference >= 1 THEN 'Mobile Fan'
        WHEN Difference <= -2 THEN 'Online Super Fan'
        WHEN Difference <= -1 THEN 'Online Fan'
    END as Preference

FROM LONG_TABLE
PIVOT (SUM(value) FOR device IN ('MOBILE','ONLINE'))

GROUP BY CUSTOMER_ID
)

SELECT Preference
    ,Round((COUNT(Preference)/SUM(COUNT(Preference)) OVER())*100,2) as "% of Total"

From Preference_Table

Group BY Preference
