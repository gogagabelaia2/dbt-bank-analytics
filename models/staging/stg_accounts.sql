with source as (
    select * from {{ source('bank_raw', 'accounts') }}
),
cleaned as (
    select
        account_id,
        customer_id,
        branch_id,
        trim(account_number)    as account_number,
        lower(trim(account_type))    as account_type,
        upper(trim(currency))     as currency,
        balance,
        lower(trim(status))   as status,
        opened_date,
        created_at
    from source
)
select * from cleaned
