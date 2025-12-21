{{ config(materialized='table') }}

with rfm as (
    select *
    from {{ ref('customer_rfm_v2') }}
),

ltv as (
    select
        CUSTOMER_ID,
        FREQUENCY,
        MONETARY,
        (FREQUENCY * MONETARY * 1.5) as LIFETIME_VALUE  -- Choose a multiplier for lifespan
    from rfm
)

select * from ltv
