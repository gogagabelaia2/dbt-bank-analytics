select npl_ratio
from {{ ref('fct_loan_portfolio') }}
where npl_ratio > 50