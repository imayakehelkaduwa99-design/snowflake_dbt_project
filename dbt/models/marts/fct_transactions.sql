{{ config(materialized="table") }}

-- Transaction Fact Table
select
    t.transaction_id,
    t.customer_id,
    t.transaction_date,
    t.product_sku,
    t.product_description,
    t.product_category,
    t.quantity,
    t.avg_price,
    t.delivery_charges,
    t.coupon_status,
    t.coupon_code,
    t.discount_pct,
    t.payment_method,
    t.shipping_provider,
    t.transaction_rating,
    -- Revenue calculation
    (t.quantity * t.avg_price) as gross_revenue,
    (t.quantity * t.avg_price) 
        - ((t.quantity * t.avg_price) * (t.discount_pct / 100)) 
        as net_revenue
from {{ ref('stg_transactions') }} t
