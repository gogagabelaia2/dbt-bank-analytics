with customer_balances as (
    select
        customer_id,
        customer_type,
        country_code,
        city,
        onboarding_date,
        total_accounts,
        total_balance,
        has_loan,
        total_outstanding_debt,
        customer_segmented
    from {{ ref('int_customer_balances') }}
)

select * from customer_balances