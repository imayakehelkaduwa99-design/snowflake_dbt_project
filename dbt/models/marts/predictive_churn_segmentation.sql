with customer_metrics as (
    select
        CUSTOMER_ID,
        max(to_date(TRANSACTION_DATE, 'DD/MM/YYYY')) as LAST_PURCHASE_DATE,
        count(*) as FREQUENCY,
        sum(NET_REVENUE) as MONETARY
    from PROJECT1_ANALYTICS.dbt_ikehelkaduwa.fct_transactions
    group by 1
),

recency_calc as (
    select
        CUSTOMER_ID,
        FREQUENCY,
        MONETARY,
        datediff('day', LAST_PURCHASE_DATE, current_date()) as RECENCY
    from customer_metrics
),

segmentation as (
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
    from recency_calc
)

select *
from segmentation
order by RECENCY desc
