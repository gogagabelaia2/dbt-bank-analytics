with source as (
    select * from {{ source('bank_raw', 'customers') }}
),
cleaned as (
    select
        customer_id,
        lower(trim(customer_type))   as customer_type,
        initcap(trim(first_name))   as first_name,
        initcap(trim(last_name))   as last_name,
        lower(trim(email))    as email,
        lower(trim(gender))   as gender,
        upper(trim(country_code))    as country_code,
        initcap(trim(country_name))   as country_name,
        initcap(trim(city))   as city,
        onboarding_date,
        created_at
    from source
)
select * from cleaned