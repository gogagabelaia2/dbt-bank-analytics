with source as (
    select * from {{ source('bank_raw', 'transactions') }}
),
renamed as (
    select
        transaction_id,
        account_id,
        customer_id,
        transaction_date,
        lower(trim(transaction_type))   as transaction_type,
        lower(trim(transaction_category))   as transaction_category,
        amount,
        upper(trim(currency))   as currency,
        lower(trim(status))   as status,
        trim(reference_number)   as reference_number,
        nullif(trim(description), '')   as description,
        created_at
    from source
)
select * from renamed