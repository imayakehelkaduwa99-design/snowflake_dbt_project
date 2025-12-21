{{ config(materialized='table') }}

with purchases as (
    select
        CUSTOMER_ID,
        date_trunc(
            'month',
            to_date(TRANSACTION_DATE, 'DD/MM/YYYY')
        ) as PURCHASE_MONTH
    from {{ ref('fct_transactions') }}
),

first_purchase as (
    select
        CUSTOMER_ID,
        min(PURCHASE_MONTH) as FIRST_MONTH
    from purchases
    group by 1
),

repeaters as (
    select
        p.CUSTOMER_ID
    from purchases p
    join first_purchase fp
        on p.CUSTOMER_ID = fp.CUSTOMER_ID
        and p.PURCHASE_MONTH > fp.FIRST_MONTH
    group by 1
)

select
    count(*) as repeat_customers,
    (select count(distinct CUSTOMER_ID) from purchases) as total_customers,
    count(*) / nullif((select count(distinct CUSTOMER_ID) from purchases),0) as repeat_purchase_rate
from repeaters
