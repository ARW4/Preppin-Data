SELECT split_part(transaction_code , '-',1) as Bank
    ,SUM(value) VALUE
    
FROM PD2023_WK01

GROUP BY Bank;

-----------------------------------------------------------------------------------

SELECT SPLIT_PART(transaction_code, '-',1) AS Bank
    ,iff(online_or_in_person = 1 , 'Online', 'In-Person') as Online_or_IN_Person
    ,Dayname(Date(transaction_date, 'dd/mm/yyyy hh24:mi:ss')) as Day_Of_Week
    ,sum(value) as Value
    
FROM pd2023_wk01

GROUP BY Bank, ONLINE_OR_IN_PERSON, Day_Of_Week;

-- -----------------------------------------------------------------------------------
SELECT split_part(transaction_code ,'-', 1) as Bank
    ,CUSTOMER_CODE as Customer
    ,sum(Value) as Value

FROM pd2023_wk01

group by Bank, Customer
