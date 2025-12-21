{{ config(
    materialized = 'view'
) }}

-- Stage transaction data from the GOOGLE_DRIVE schema
with source as (

    select *
    from PROJECT1_ANALYTICS.GOOGLE_DRIVE.TRANSACTION_A_2

)

select
    Customer_ID         as customer_id,
    Transaction_ID      as transaction_id,
    Transaction_Date    as transaction_date,
    Product_SKU         as product_sku,
    Product_Description as product_description,
    Product_Category    as product_category,
    Quantity            as quantity,
    Avg_Price           as avg_price,
    Delivery_Charges    as delivery_charges,
    Coupon_Status       as coupon_status,
    Coupon_Code         as coupon_code,
    Discount_pct        as discount_pct,
    Payment_Method      as payment_method,
    Shipping_Provider   as shipping_provider,
    Transaction_Rating  as transaction_rating
from source
