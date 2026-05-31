-- models/intermediate/int_financial_summary.sql
with source as (
    select * from {{ ref('stg_financial_summary') }}
),
final as (
    select
        sum(interest_income)  as total_interest_income,
        sum(interest_expense) as total_interest_expense,
        sum(total_assets)     as total_assets
    from source
)
select * from final