with loans as (
    select * from {{ ref('stg_loans') }}
)

select 
    count(loan_id) as loan_count,
    {{dpd_bucket('days_past_due')}}
from loans
GROUP BY 2
