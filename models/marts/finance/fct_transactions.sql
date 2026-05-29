with transactions as(
    select * from {{ref('int_monthly_transactions')}}
),
final as(
    select
        sum(total_volume) as total_volume,
        sum(transaction_count) as transaction_count,
        sum(credit_volume) as credit_volume,
        sum(debit_volume) as debit_volume,
        (sum(credit_volume) - sum(debit_volume)) as net_volume,
        round(
            {{ safe_divide (
                'sum(total_volume)',
                'sum(transaction_count)'
        )}}
        , 2) as avg_transaction
    from transactions
)
select * from final
