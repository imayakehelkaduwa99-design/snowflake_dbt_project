with monthly_revenue as (
    select
        date_trunc('month', to_date(TRANSACTION_DATE, 'DD/MM/YYYY')) as MONTH,
        CUSTOMER_ID,
        sum(NET_REVENUE) as customer_revenue
    from PROJECT1_ANALYTICS.dbt_ikehelkaduwa.fct_transactions
    group by 1,2
),

-- ACTIVE CUSTOMER LIST PER MONTH AS ARRAY
active_by_month as (
    select
        MONTH,
        array_agg(distinct CUSTOMER_ID) as active_customers,
        count(distinct CUSTOMER_ID) as active_count
    from monthly_revenue
    group by 1
),

-- EXPLODE PREVIOUS MONTH CUSTOMERS INTO ROWS
prev_month_customers as (
    select
        curr.MONTH,
        p.value::string as CUSTOMER_ID
    from active_by_month curr
    left join active_by_month prev
        on dateadd('month', 1, prev.MONTH) = curr.MONTH,
         lateral flatten(prev.active_customers) p
),

-- EXPLODE CURRENT MONTH CUSTOMERS INTO ROWS
curr_month_customers as (
    select
        MONTH,
        c.value::string as CUSTOMER_ID
    from active_by_month,
         lateral flatten(active_customers) c
),

-- FIND CUSTOMERS WHO WERE ACTIVE LAST MONTH BUT NOT ACTIVE THIS MONTH
churned_list as (
    select
        pm.MONTH,
        pm.CUSTOMER_ID
    from prev_month_customers pm
    left join curr_month_customers cm
        on pm.MONTH = cm.MONTH
        and pm.CUSTOMER_ID = cm.CUSTOMER_ID
    where cm.CUSTOMER_ID is null
),

-- SUM REVENUE OF CHURNED CUSTOMERS
churned_revenue as (
    select
        cl.MONTH as churn_month,
        sum(mr.customer_revenue) as churned_customer_revenue
    from churned_list cl
    join monthly_revenue mr
        on mr.CUSTOMER_ID = cl.CUSTOMER_ID
        and mr.MONTH = dateadd('month', -1, cl.MONTH)   -- 🆕 LAST ACTIVE MONTH
    group by 1
),


-- TOTAL NET REVENUE PER MONTH
total_monthly_revenue as (
    select
        MONTH,
        sum(customer_revenue) as total_revenue
    from monthly_revenue
    group by 1
)

-- FINAL OUTPUT
select
    tmr.MONTH,
    tmr.total_revenue,
    coalesce(cr.churned_customer_revenue,0) as churned_customer_revenue,
    coalesce(cr.churned_customer_revenue,0) / nullif(tmr.total_revenue,0) as revenue_risk_rate
from total_monthly_revenue tmr
left join churned_revenue cr
    on tmr.MONTH = cr.churn_month
order by tmr.MONTH
