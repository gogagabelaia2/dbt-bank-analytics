with loans as(
    SELECT
        loan_id,
        customer_id,
        account_id,
        loan_type,
        original_amount,
        outstanding_balance,
        days_past_due
    from {{ref('stg_loans')}}
),
deposits as(
    SELECT  
        deposit_id,
        customer_id,
        account_id,
        principal_amount
    from {{ref('stg_deposits')}}
),
transactions as(
    select
        transaction_id,
        account_id,
        customer_id,
        transaction_date,
        lower(trim(transaction_type))   as transaction_type,
        lower(trim(transaction_category))   as transaction_category,
        amount,
        status
    from {{ref('stg_transactions')}}
),
loan_metrics as (
    select sum(outstanding_balance) as total_loans
    from loans
),
deposit_metrics as (
    select sum(principal_amount) as total_deposits
    from deposits
),
transaction_metrics as (
    select
        count(*) as total_transactions,
        sum(case when status = 'failed' then 1 else 0 end) as failed_transactions
    from transactions
),
final as (
    select
        round({{ safe_divide('l.total_loans', 'd.total_deposits') }} * 100, 2) as ldr,
        round({{ safe_divide('t.failed_transactions', 't.total_transactions') }} * 100, 2) as failed_transaction_rate
    from loan_metrics l
    cross join deposit_metrics d
    cross join transaction_metrics t
)
select * from final