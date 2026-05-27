with source as (
    select * from {{ source('bank_raw', 'financial_summary') }}
),
renamed as (
    select
        summary_id,
        report_date,
        interest_income,
        interest_expense,
        net_income,
        total_assets,
        total_loans_gross,
        total_deposits
    from source
)
select * from renamed