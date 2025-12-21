{{ config(materialized="table") }}

-- Customer Dimension Table
select
    customer_id,
    chatbot_usage_count,
    last_chatbot_interaction,
    email_opened_count,
    clicked_ad_campaigns,
    participated_in_survey,
    preferred_channel,
    loyalty_program_status,
    marketing_responsiveness,
    referral_likelihood,
    gender,
    tenure_months
from {{ ref('stg_customers') }}
