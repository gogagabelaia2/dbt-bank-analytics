with profitability as (
    select * from {{ ref('int_bank_profitability') }}
),

financial_summary as (
    select
        sum(interest_income)    as total_interest_income,
        sum(interest_expense)   as total_interest_expense,
        sum(total_assets)       as total_assets
    from {{ ref('stg_financial_summary') }}
),

final as (
    select
        p.ldr,
        p.failed_transaction_rate,
        round(
            {{ safe_divide(
                '(f.total_interest_income - f.total_interest_expense)',
                'f.total_assets'
            ) }} * 100
        , 4) as nim
    from profitability p
    cross join financial_summary f
)

select * from final