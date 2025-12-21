{{ config(materialized='table') }}

with rfm as (
    select
        CUSTOMER_ID,
        RECENCY,
        FREQUENCY,
        MONETARY
    from {{ ref('customer_rfm_v2') }}
)

select
    CUSTOMER_ID,
    RECENCY,
    FREQUENCY,
    MONETARY,

    case 
        when RECENCY > 180 then 'Churn Risk'
        when RECENCY between 120 and 180 then 'At Risk'
        else 'Healthy'
    end as churn_status

from rfm
