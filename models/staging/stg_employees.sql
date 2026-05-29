with source as (
    select * from {{ source('bank_raw', 'employees') }}
),
renamed as (
    select
        employee_id,
        upper(trim(employee_code))    as employee_code,
        initcap(trim(first_name))     as first_name,
        initcap(trim(last_name))      as last_name,
        branch_id,
        lower(trim(department))      as department,
        salary,
        created_at
    from source
)
select * from renamed