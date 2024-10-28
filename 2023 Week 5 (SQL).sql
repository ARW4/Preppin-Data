With Month_CTE as (
SELECT *
    ,split_part(transaction_code,'-',1) as BANK
    ,date_part('month',DATE(transaction_date,'dd/MM/yyyy hh24:mi:ss')) as Month_Number
    ,case
        when Month_Number = 1 then 'January'
        when Month_Number = 2 then 'February'
        when Month_Number = 3 then 'March'
        when Month_Number = 4 then 'April'
        when Month_Number = 5 then 'May'
        when Month_Number = 6 then 'June'
        when Month_Number = 7 then 'July'
        when Month_Number = 8 then 'August'
        when Month_Number = 9 then 'September'
        when Month_Number = 10 then 'October'
        when Month_Number = 11 then 'Novemeber'
        when Month_Number = 12 then 'December'
    End as Month
    
FROM PD2023_WK01
),

Rank_CTE as (
SELECT Bank
    ,Month
    ,sum(Value) as Value
    ,RANK() OVER (PARTITION BY Month_Number ORDER BY SUM(value) DESC) as rank
    
FROM Month_CTE

GROUP BY Bank, Month, Month_Number

ORDER BY Month_CTE.Month_Number, rank
),

AVG_VALUE_BY_RANK_CTE as (

SELECT Round(AVG(VALUE),2) as AVG_VALUE_BY_RANK
    ,Rank
FROM RANK_CTE

GROUP BY RANK
),

AVG_RANK_BY_BANK_CTE as (

SELECT Round(AVG(RANK),2) as AVG_RANK_BY_BANK
    ,Bank
FROM RANK_CTE

GROUP BY BANK
)

SELECT RANK_CTE.Month
    ,RANK_CTE.Bank
    ,RANK_CTE.Value
    ,RANK_CTE.Rank
    ,AVG_VALUE_BY_RANK_CTE.AVG_VALUE_BY_RANK
    ,AVG_RANK_BY_BANK_CTE.AVG_RANK_BY_BANK

FROM RANK_CTE

JOIN AVG_VALUE_BY_RANK_CTE on AVG_VALUE_BY_RANK_CTE.rank = RANK_CTE.rank
JOIN AVG_RANK_BY_BANK_CTE on AVG_RANK_BY_BANK_CTE.bank = RANK_CTE.Bank
