with source as (
    select * from {{ source('bank_raw', 'deposits') }}
),
renamed as (
    select
        deposit_id,
        customer_id,
        account_id,
        principal_amount,
        upper(trim(currency))    as currency,
        lower(trim(status))    as status,
        created_at
    from source
)
select * from renamed