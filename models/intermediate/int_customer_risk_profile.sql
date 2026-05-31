with customers as(
    SELECT
        customer_id,
        customer_type,
        first_name,
        last_name,
        country_name,
        city,
        onboarding_date
    from {{ref('stg_customers')}}
),
loans as(
    SELECT
        loan_id,
        customer_id,
        account_id,
        loan_type,
        original_amount,
        outstanding_balance,
        days_past_due,
        classification
    from {{ref('stg_loans')}}
),
credit_assessments as(
    SELECT
       assessment_id,
       customer_id,
       credit_score,
       monthly_income,
       decision
    from {{ref('stg_credit_assessments')}} 
),
logic as(
    SELECT
        c.customer_id,
        sum(l.outstanding_balance) as total_outstanding_balance,
        avg(ac.credit_score) as avg_credit_score,
        count(l.loan_id) as total_loans,
        COUNT(CASE WHEN l.days_past_due > 30 THEN 1 END) as overdue_loans_count
    from customers c 
    join loans l on c.customer_id = l.customer_id
    left join credit_assessments ac on c.customer_id=ac.customer_id
    group by 1
),
final as (
    SELECT
        *,
        CASE 
            WHEN overdue_loans_count >= 2 THEN 'HIGH'
            WHEN overdue_loans_count = 1  THEN 'MEDIUM'
            ELSE                               'LOW'
        END as risk_category
    FROM logic
)
select * from final