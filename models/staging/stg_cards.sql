with source as (
    select * from {{ source('bank_raw', 'cards') }}
),
renamed as (
    select
        card_id,
        account_id,
        customer_id,
        lower(trim(card_type))      as card_type,
        lower(trim(card_network))     as card_network,
        lower(trim(status))    as status,
        created_at
    from source
)
select * from renamed
 