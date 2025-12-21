{{ config(materialized='table') }}

with base as (
    select
        PRODUCT_CATEGORY,
        date_trunc('month', TO_DATE(TRANSACTION_DATE, 'DD/MM/YYYY')) as MONTH,
        sum(NET_REVENUE) as REVENUE
    from {{ ref('fct_transactions') }}
    group by 1,2
)

select * from base
