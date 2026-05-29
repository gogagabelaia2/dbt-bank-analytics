with transactions as(
    SELECT
        transaction_id,
        account_id,
        transaction_date,
        transaction_type,
        amount
    from {{ref('stg_transactions')}}
),
logic as(
    SELECT  
        date_trunc('month',transaction_date) as transaction_month,
        account_id,
        count(*) as transaction_count,
        sum(amount) as total_volume,
        avg(amount) as avg_transaction,
        sum(amount)filter(where transaction_type = 'credit') as credit_volume,
        sum(amount)filter(where transaction_type = 'debit') as debit_volume
    from transactions
    group by 1,2
)
SELECT * from logic