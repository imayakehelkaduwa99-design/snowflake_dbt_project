with purchases as (
    select 
        CUSTOMER_ID,
        date_trunc('month', TO_DATE(TRANSACTION_DATE, 'DD/MM/YYYY')) as MONTH
    from PROJECT1_ANALYTICS.dbt_ikehelkaduwa.fct_transactions
    group by 1,2
),

-- active customers per month
active_by_month as (
    select
        MONTH,
        CUSTOMER_ID
    from purchases
),

-- previous month mapping
monthly_pairs as (
    select
        curr.MONTH as MONTH,
        prev.MONTH as PREV_MONTH,
        curr.CUSTOMER_ID as CURR_CUSTOMER,
        prev.CUSTOMER_ID as PREV_CUSTOMER
    from active_by_month curr
    left join active_by_month prev
        on prev.MONTH = dateadd('month', -1, curr.MONTH)
)

-- churn = prev customers who do not appear this month
select
    MONTH,
    count(distinct CURR_CUSTOMER) as active_customers,
    count(distinct PREV_CUSTOMER) -
        count(distinct case when PREV_CUSTOMER = CURR_CUSTOMER then PREV_CUSTOMER end) 
        as churned_customers,
    (
        (
            count(distinct PREV_CUSTOMER) -
            count(distinct case when PREV_CUSTOMER = CURR_CUSTOMER then PREV_CUSTOMER end)
        ) * 1.0
    ) / nullif(count(distinct PREV_CUSTOMER),0) as churn_rate
from monthly_pairs
group by MONTH
order by MONTH
