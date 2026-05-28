with deposits as (
    select
        customer_id,
        principal_amount
    from {{ ref('stg_deposits') }}
),
customer_totals as (
    select
        customer_id,
        sum(principal_amount) as customer_total_deposit
    from deposits
    group by customer_id
),
final as (
    select
        customer_id,
        customer_total_deposit,
        sum(customer_total_deposit) over ()  as bank_total_deposits,
        {{ safe_divide('customer_total_deposit * 100', 
            'sum(customer_total_deposit) over()') }} 
                as deposit_concentration_pct
    from customer_totals
)
select * from final