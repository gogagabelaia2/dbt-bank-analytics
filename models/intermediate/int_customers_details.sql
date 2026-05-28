-- models/intermediate/int_customer_details.sql

with customers as (
    select * from {{ ref('stg_customers') }}
),

country_risk as (
    select * from {{ ref('country_risk_tiers') }}
),

account_summary as (
    select
        customer_id,
        count(*)        as total_accounts,
        sum(balance)    as total_balance
    from {{ ref('stg_accounts') }}
    group by customer_id
),

latest_credit as (
    select distinct on (customer_id)
        customer_id,
        credit_score,
        monthly_income,
        decision as latest_credit_decision
    from {{ ref('stg_credit_assessments') }}
    order by customer_id, created_at desc
),

final as (
    select
        c.customer_id,
        c.customer_type,
        c.first_name,
        c.last_name,
        c.email,
        c.country_code,
        c.onboarding_date,

        -- macro
        {{ classify_customer_type('c.customer_type') }} as customer_segment,

        -- seed
        cr.risk_tier,
        cr.aml_flag,

        -- accounts
        coalesce(a.total_accounts, 0) as total_accounts,
        coalesce(a.total_balance, 0)  as total_balance,

        -- credit
        lc.credit_score,
        lc.monthly_income,
        lc.latest_credit_decision,

        -- tenure
        current_date - c.onboarding_date as customer_tenure_days

    from customers c
    left join country_risk cr on c.country_code = cr.country_code
    left join account_summary a on c.customer_id = a.customer_id
    left join latest_credit lc on c.customer_id = lc.customer_id
)

select * from final