with transactions as( 
    SELECT  
        transaction_id,
        customer_id,
        account_id,
        transaction_date,
        transaction_type,
        amount,
        status
    from {{ref('stg_transactions') }}

),
logic as(
    SELECT
        date_trunc('month',transaction_date) as month,
        count(*) as total_transaction,
        sum(amount) as total_amount,
        sum(case when status = 'failed' then 1 else 0 end) as failed_count,
        {{ safe_divide('sum(case when status = \'failed\' then 1 else 0 end)', 'count(*)') }} as failure_rate
    from transactions
    group by 1

)
select * from logic