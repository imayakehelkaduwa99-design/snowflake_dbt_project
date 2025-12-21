{{ config(materialized='table') }}

with base as (
    select
        CUSTOMER_ID,
        try_to_date(TRANSACTION_DATE, 'DD/MM/YYYY') as PURCHASE_DATE,
        NET_REVENUE,
        date_trunc('month', try_to_date(TRANSACTION_DATE, 'DD/MM/YYYY')) as PURCHASE_MONTH,
        min(try_to_date(TRANSACTION_DATE, 'DD/MM/YYYY')) over (partition by CUSTOMER_ID) as FIRST_PURCHASE_DATE
    from {{ ref('fct_transactions') }}
),

cohorts as (
    select
        CUSTOMER_ID,
        date_trunc('month', FIRST_PURCHASE_DATE) as COHORT_MONTH,
        PURCHASE_MONTH,
        sum(NET_REVENUE) as MONTHLY_SPEND
    from base
    group by CUSTOMER_ID, COHORT_MONTH, PURCHASE_MONTH
)

select *
from cohorts
