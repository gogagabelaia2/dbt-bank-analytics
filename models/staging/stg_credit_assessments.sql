with source as (
    select * from {{ source('bank_raw', 'credit_assessments') }}
),
renamed as (
    select
        assessment_id,
        customer_id,
        credit_score,
        case
            when monthly_income < 0 then null
            else monthly_income
        end  as  monthly_income,
        lower(trim(decision))  as decision,
        created_at
    from source
)
select * from renamed