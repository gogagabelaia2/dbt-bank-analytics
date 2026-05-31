with loan_payments as(
    SELECT  
        payment_id,
        loan_id,
        customer_id,
        total_paid,
        payment_status,
        created_at
    from {{ref('stg_loan_payments')}}
),
loans as(
    SELECT  
        loan_id,
        customer_id,
        loan_type,
        original_amount,
        created_at
    from {{ref('stg_loans')}}

),
logic as(
    select
    l.loan_id,
    l.loan_type,
    l.original_amount,
    sum(lp.total_paid) as total_paid,
    {{ safe_divide('sum(lp.total_paid) * 100.0', 'l.original_amount') }} as repayment_rate
from loan_payments lp
left join loans l on lp.loan_id = l.loan_id
group by l.loan_id, l.loan_type, l.original_amount

)
select * from logic