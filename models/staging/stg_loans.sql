with source as (
    select * from {{ source('bank_raw', 'loans') }}
),
renamed as (
    select
        loan_id,
        customer_id,
        account_id,
        lower(trim(loan_type))    as loan_type,
        original_amount,
        outstanding_balance,
        coalesce(days_past_due, 0)      as days_past_due,
        initcap(trim(classification))    as classification,
        created_at
    from source
)
select * from renamed