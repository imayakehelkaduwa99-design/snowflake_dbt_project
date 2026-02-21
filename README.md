**Sales Analytics Engineering Project (Snowflake + Fivetran + dbt)**

Project Overview
This project demonstrates an end-to-end modern analytics engineering pipeline using:
1. **Google Drive** as the source system (CSV files)
2. **Fivetran** for automated ELT ingestion
3. **Snowflake** as the cloud data warehouse
4. **dbt** for transformations, testing, and analytics modelling

The goal is to:
- Build a clean, scalable transformation layer using dbt
- Model customer and revenue analytics using fact and dimension tables
- Enable advanced analytics such as cohort analysis, churn segmentation, RFM segmentation, customer lifetime value (LTV), repeat purchase rate, and revenue trends
- Demonstrate modern analytics engineering best practices: staging → marts → metrics

This repository contains the complete dbt project, including staging models, fact tables, dimension tables,
analytics marts, and documented transformation lineage.

All transformations are authored in dbt and materialized into Snowflake

**Tech Stack**
1. Google Drive (Source storage)
2. Fivetran (ELT ingestion)
3. Snowflake (cloud data warehouse)
4. dbt (transformations, modeling, lineage)
5. Power BI (Visualisation layer)

**Data Sources**
Two datasets are used as the foundation of this project:
1. Customer_Data.csv - customer master data
2. Transaction_Data.csv - transaction-level sales data

**Ingestion Flow**
1. CSV file are stored in Google Drive
2. Fivetran connects to Google Drive and syncs the files
3. Data is loaded into Snowflake as raw tables
4. dbt transforms the raw data into analytics-ready models

This follows a modern ELT architecture: extract & load with Fivetran, transform inside Snowflake using dbt.

**Data Pipeline Architecture**
End-to-end flow:
Google Drive (CSV)
- Fivetran (ELT Ingestion)
- Snowflake (Raw Tables)
- dbt (Staging → Facts / Dimensions → Analytics Marts)
- Analytics-ready tables for reporting & insights

**Data Pipeline Overview**

This project implements a modern analytics engineering pipeline:

CSV Files (hosted in Google Drive)  
↓  
**Fivetran**  
Automated ELT ingestion from Google Drive into Snowflake  
↓  
**Snowflake**  
Raw data warehouse layer (source tables)  
↓  
**dbt Staging Models** (`stg_*`)  
Data cleaning, type casting, and standardisation  
↓  
**dbt Fact & Dimension Models** (`fct_*`, `dim_*`)  
Core analytical models for metrics and reporting  
↓  
**dbt Marts**  
Business-ready tables: Customer 360, RFM Segmentation, LTV, Cohort Analysis, Revenue Trends, Churn Analysis, etc.  
↓  
**Analytics / BI Layer**  
Power BI dashboards (planned)

The pipeline is designed to be:
1. Scalable
2. Reproducible
3. Modular
4. Fully documented via dbt lineage graphs

**dbt Project Structure**
The dbt project is organised into clear modelling layers:
Staging Layer (models/staging)
1. stg_customers
2. stg_transactions

Purpose:
1. Clean raw data
2. Standardise column names
3. Cast data types
4. Apply basic transformations

**Core Models (Facts & Dimensions)**
1. fct_transactions - central transaction fact table
2. dim_customers - customer dimension table
3. fct_customer_metrics - aggregated customer metrics

Purpose:
1. Create reliable, reusable core business entities
2. Serve as the foundation for analytics models

**Analytics & Marts Layer (models/marts)**
1. monthly_revenue
2. product_category_revenue_trends
3. repeat_purchase_rate
4. cohort_analysis
5. customer_360
6. customer_rfm_v2
7. customer_rfm_segmented
8. customer_ltv
9. customer_churn_segmentation

Purpose:
1. Deliver business-ready tables for analysis
2. Support customer analytics, growth, and retention use cases

**Data Model & Lineage**
dbt's lineage graph is used to document and visualise:
1. How raw data flows into staging models
2. How staging feeds fact and dimension tables
3. How analytics models depend on core tables
4. How business metrics and derived end-to-end

The lineage clearly shows:
- stg_*models → fct_* / dim_* → analytics marts (LTV, RFM, churn, cohorts, etc.)
- Reusable transformation logic
- A modular, maintainable modelling approach

Lineage screenshots are included in the repository as dbt_lineage_1, etc.

**Business Questions Answered**
This project enables answers to questions such as:
1. How is revenue trending over time?
2. What is the monthly revenue by product category?
3. What is the repeat purchase rate?
4. How do customer cohorts behave over time?
5. Which customers are high value vs low value?
6. What is the customer lifetime value (LTV)?
7. How can customers be segmented using RFM?
8. Which customers are at risk of churn?
9. How can we build a 360 degree customer view for analytics?

**KPIs Produced**
- Monthly Revenue
- Monthly Churn Rate
- Repeat Purchase Rate
- Customer Lifetime Value (LTV)
- RFM Scores & Segments
- Cohort Retention Metrics
- Revenue by Product Category
- Customer-Level Performance Metrics

These models are designed to feed BI tools such as Power BI for dashboarding.

**Data Quality & Modelling Practices**
- Clear separation of staging, core, and mart layers
- Use of dbt ref() for dependency management
- Consistent naming conventions
- Reusable fact and dimension models
- Documented sources and models via sources.yml
- Materialization strategy:
  1. Staging: views
  2. Marts: tables

**How to Run This Project**
1. Ensure Snowflake and dbt profiles are configured
2. Install dependencies (if any)
3. Run the project:
   dbt build
or run the models only:
    dbt run
To generate documentation locally:
   dbt docs generate
   dbt docs serve

**Why This Project Matters**
This project demonstrates:
1. Real-world ELT architecture using Fivetran + Snowflake + dbt
2. Analytics engineering best practices
3. Dimensional modelling (facts & dimensions)
4. Customer analytics use cases (LTV, RFM, churn, cohorts)
5. End-to-end ownership of a data pipeline
6. Production-style transformation workflows

It reflects how modern data teams build scalable, trustworthy analytics platforms
in practice.

**Evidence & Documentation**
This repository includes:
- dbt lineage graph screenshots
- Fivetran connection & destination screenshots
- Source definitions (sources.yml)
- dbt project configuration (dbt_project.yml)
- Full transformation logic in dbt models

**Author**
Imaya Kehelkaduwa
Analytics / Data Engineering Portfolio Project
Built using Snowflake, Fivetran, and dbt

