with loans as(
    SELECT
        loan_id,
        loan_type,
        original_amount,
        outstanding_balance,
        days_past_due,
        classification
    from {{ref('stg_loans')}}
),
logic as(
    select 
        round(sum(original_amount) filter(where classification in ('Substandard', 'Doubtful', 'Loss'))
        *100.0 /sum(original_amount),2) as npl_ratio
        from loans
)
select * from logic