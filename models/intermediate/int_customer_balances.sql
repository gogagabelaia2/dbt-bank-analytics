with customers as (
    select 
        customer_id,
        customer_type,
        country_code,
        city,
        onboarding_date 
    from {{ref('stg_customers')}}
),
loans as(
    select
        loan_id,
        customer_id,
        outstanding_balance
    from {{ref('stg_loans')}}
),
accounts as(
    select
        account_id,
        customer_id,
        balance
    from {{ref('stg_accounts')}}
),
logic as(
    SELECT
        c.customer_id,
        c.customer_type,
        c.country_code,
        c.city,
        c.onboarding_date,
        count(ac.account_id) as total_accounts,
        sum(ac.balance) as total_balance,
        case when count(l.loan_id) > 0 then true else false end as has_loan,
        sum(l.outstanding_balance) as total_outstanding_debt
    from customers c
    left join loans l on c.customer_id = l.customer_id
    left join accounts ac on c.customer_id = ac.customer_id
    group by
        c.customer_id,
        c.customer_type,
        c.country_code,
        c.city,
        c.onboarding_date
),
final as(
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
        {{ customer_segment('total_balance') }} as customer_segmented
    from logic
)
select * from final