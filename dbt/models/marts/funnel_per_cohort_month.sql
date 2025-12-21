with purchases as (
    select
        CUSTOMER_ID,
        date_trunc('month', to_date(TRANSACTION_DATE, 'DD/MM/YYYY')) as PURCHASE_MONTH
    from PROJECT1_ANALYTICS.dbt_ikehelkaduwa.fct_transactions
),

first_purchase as (
    select
        CUSTOMER_ID,
        min(PURCHASE_MONTH) as COHORT_MONTH
    from purchases
    group by 1
),

repeaters as (
    select distinct
        p.CUSTOMER_ID,
        fp.COHORT_MONTH
    from purchases p
    join first_purchase fp
        on p.CUSTOMER_ID = fp.CUSTOMER_ID
        and p.PURCHASE_MONTH > fp.COHORT_MONTH
),

funnel as (
    select
        fp.COHORT_MONTH,
        count(distinct fp.CUSTOMER_ID) as cohort_new_customers,
        count(distinct r.CUSTOMER_ID) as cohort_repeat_customers
    from first_purchase fp
    left join repeaters r
        on fp.CUSTOMER_ID = r.CUSTOMER_ID
        and fp.COHORT_MONTH = r.COHORT_MONTH
    group by 1
)

select
    *,
    cohort_repeat_customers / nullif(cohort_new_customers,0) as conversion_rate
from funnel
order by COHORT_MONTH
