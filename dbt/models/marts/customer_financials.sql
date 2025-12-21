with base as (
    select
        CUSTOMER_ID,
        to_date(TRANSACTION_DATE, 'DD/MM/YYYY') as PURCHASE_DATE,
        NET_REVENUE
    from PROJECT1_ANALYTICS.DBT_IKEHELKADUWA.fct_transactions
),


customer_agg as (
    select
        CUSTOMER_ID,
        count(*) as total_transactions,
        sum(NET_REVENUE) as total_revenue,
        avg(NET_REVENUE) as avg_order_value,
        max(PURCHASE_DATE) as last_purchase_date,
        min(PURCHASE_DATE) as first_purchase_date
    from base
    group by 1
),

recency_calc as (
    select
        CUSTOMER_ID,
        total_transactions,
        total_revenue,
        avg_order_value,
        last_purchase_date,
        first_purchase_date,
        datediff('day', last_purchase_date, current_date) as recency
    from customer_agg
)

select *
from recency_calc
