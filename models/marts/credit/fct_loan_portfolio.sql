with loans as (
    select * from {{ ref('int_loan_status') }}
),

final as (
    select
        count(loan_id)                                              as total_loans,
        sum(outstanding_balance)                                    as total_outstanding_balance,
        sum(case when is_npl then outstanding_balance else 0 end)   as npl_amount,
        round(
            {{ safe_divide(
                'sum(case when is_npl then outstanding_balance else 0 end)',
                'sum(outstanding_balance)'
            ) }}
        , 4)                                                        as npl_ratio,
        sum(npl_provision)                                          as total_provision
    from loans
)

select * from final