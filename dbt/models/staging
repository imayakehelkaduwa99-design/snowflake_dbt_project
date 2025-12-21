{{ config(materialized="view") }}

-- Stage customer data from the GOOGLE_DRIVE schema
with source as (select * from project1_analytics.google_drive.customer_a_2)

select
    customer_id as customer_id,
    chatbot_usage_count as chatbot_usage_count,
    last_chatbot_interaction as last_chatbot_interaction,
    email_opened_count as email_opened_count,
    clicked_ad_campaigns as clicked_ad_campaigns,
    participated_in_survey as participated_in_survey,
    preferred_channel as preferred_channel,
    loyalty_program_status as loyalty_program_status,
    marketing_responsiveness as marketing_responsiveness,
    referral_likelihood as referral_likelihood,
    gender as gender,
    tenure_months as tenure_months
from source
