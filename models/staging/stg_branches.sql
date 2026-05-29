with source as (
    select * from {{ source('bank_raw', 'branches') }}
),
renamed as (
    select
        branch_id,
        upper(trim(branch_code))      as branch_code,
        initcap(trim(branch_name))    as branch_name,
        upper(trim(country_code))     as country_code,
        initcap(trim(country_name))     as country_name,
        initcap(trim(city))     as city,
        latitude,
        longitude,
        created_at
    from source
)
select * from renamed