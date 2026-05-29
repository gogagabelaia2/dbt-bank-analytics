with source as (
    select * from {{ source('bank_raw', 'collateral') }}
),
renamed as (
    select
        collateral_id,
        loan_id,
        customer_id,
        lower(trim(collateral_type))   as collateral_type,
        current_value,
        created_at
    from source
)
select * from renamed