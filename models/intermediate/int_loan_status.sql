with loans as (
    select
        loan_id,
        customer_id,
        account_id,
        loan_type,
        original_amount,
        outstanding_balance,
        days_past_due,
        classification
    from {{ ref('stg_loans') }}
),

loan_payments as (
    select * from {{ ref('stg_loan_payments') }}
),

with_status as (
    select
        l.loan_id,
        l.customer_id,
        l.account_id,
        l.loan_type,
        l.original_amount,
        l.outstanding_balance,
        l.days_past_due,
        l.classification,
        {{ dpd_bucket('l.days_past_due') }}  as loan_status,
        case
            when l.days_past_due > 90 then true else false
        end as is_npl,
        {{ provision_rate('l.days_past_due') }} as provision_rate,
        coalesce(lp.total_paid, 0) as total_paid
    from loans l
    left join loan_payments lp on l.loan_id = lp.loan_id
),

final as (
    select
        *,
        round(outstanding_balance * provision_rate , 2) as npl_provision
    from with_status
)

select * from final