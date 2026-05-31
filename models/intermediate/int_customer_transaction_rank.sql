with transactions as(
    SELECT
        transaction_id,
        account_id,
        customer_id,
        transaction_date,
        transaction_type,
        transaction_category,
        amount,
        status
    from {{ref('stg_transactions')}}
),
logic as(
    SELECT
        customer_id,
        transaction_id,
        transaction_date,
        amount,
        row_number()over(partition by customer_id
            order by transaction_date) as transaction_rank,
        sum(amount) over(partition by customer_id 
            order by transaction_date,transaction_id ) as running_total
   from transactions
)
select * from logic