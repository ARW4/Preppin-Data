WITH CTE_Codes
    AS (SELECT Bank
        ,SWIFT_CODE
        ,CHECK_DIGITS
        FROM pd2023_wk02_swift_codes)

SELECT 'GB' || Check_Digits || Swift_Code || Replace(SORT_CODE, '-','') || ACCOUNT_NUMBER as IBAN
FROM pd2023_wk02_transactions T

JOIN CTE_Codes
    ON CTE_Codes.Bank = T.Bank
