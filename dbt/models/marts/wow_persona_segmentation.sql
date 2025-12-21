with cf as (
    select *
    from {{ ref('customer_financials') }}
),

-- QUARTILE CALCULATIONS FOR AUTOMATED THRESHOLDS
revenue_stats as (
    select
        percentile_cont(0.75) within group (order by total_revenue) as rev_p75,
        percentile_cont(0.25) within group (order by total_revenue) as rev_p25
    from cf
),

freq_stats as (
    select
        percentile_cont(0.75) within group (order by total_transactions) as freq_p75,
        percentile_cont(0.25) within group (order by total_transactions) as freq_p25
    from cf
),

segmented as (
    select
        cf.*,
        case
            when total_revenue >= (select rev_p75 from revenue_stats)
             and total_transactions >= (select freq_p75 from freq_stats)
            then 'Whale'

            when total_revenue >= (select rev_p75 from revenue_stats)
             and total_transactions < (select freq_p75 from freq_stats)
            then 'Champion'

            when total_revenue < (select rev_p25 from revenue_stats)
             and total_transactions >= (select freq_p75 from freq_stats)
            then 'Loyal Repeater'

            when recency > 90
             and total_revenue >= (select rev_p75 from revenue_stats)
            then 'At-Risk Whale'

            when total_transactions = 1
            then 'One-Timer'

            else 'Standard'
        end as persona
    from cf
)

select *
from segmented
order by persona
