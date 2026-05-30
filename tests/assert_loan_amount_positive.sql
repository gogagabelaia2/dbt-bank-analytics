select loan_id, original_amount
from {{ ref('stg_loans') }}
where original_amount <= 0