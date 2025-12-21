{{ config(materialized='table') }}

with cohorts as (
    select *
    from {{ ref('cohort_analysis') }}
),

-- Calculate cohort size (month 0 spend total)
cohort_size as (
    select
        COHORT_MONTH,
        sum(MONTHLY_SPEND) as COHORT_SPEND_MONTH0
    from cohorts
    where PURCHASE_MONTH = COHORT_MONTH
    group by COHORT_MONTH
),

-- Join cohort data with cohort size to compute retention %
retention as (
    select
        c.COHORT_MONTH,
        c.PURCHASE_MONTH,
        c.MONTHLY_SPEND,
        cs.COHORT_SPEND_MONTH0,
        c.MONTHLY_SPEND / cs.COHORT_SPEND_MONTH0 as RETENTION_RATE
    from cohorts c
    left join cohort_size cs
        on c.COHORT_MONTH = cs.COHORT_MONTH
)

select *
from retention
