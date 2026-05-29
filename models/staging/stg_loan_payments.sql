with source as (
    select * from {{ source('bank_raw', 'loan_payments') }}
),
renamed as (
    select
        payment_id,
        loan_id,
        customer_id,
        total_paid,
        lower(trim(payment_status))   as payment_status,
        created_at
    from source
)
select * from renamed