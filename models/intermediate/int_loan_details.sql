with loans as(
    SELECT
        loan_id,
        loan_type,
        original_amount,
        outstanding_balance,
        days_past_due,
        classification
    from {{ref('stg_loans')}}
),
classifications as(  
    SELECT  
        classification,   
        risk_level,
        provision_rate
    from  {{ref('loan_classifications')}} 
),
collateral as(
    select
        collateral_id,
        loan_id,
        customer_id,
        lower(trim(collateral_type)) as collateral_type,
        current_value,
        created_at
    from {{ref('stg_collateral')}}
),
collateral_summary as( 
    select
        loan_id, 
        sum(current_value) as total_value,
        count(*) as total_collateral
    from collateral
    GROUP BY loan_id
),
final as(
    select
        l.loan_id,
        l.loan_type,
        l.original_amount,
        l.outstanding_balance,
        l.days_past_due,
        l.classification,
        {{ classify_loan_risk('l.days_past_due', 'l.classification') }} as risk_category,
        {{ dpd_bucket('l.days_past_due') }} as dpd_bucket,
        c.risk_level,
        c.provision_rate,
        l.outstanding_balance * c.provision_rate as provision_amount,
        cs.total_value  as total_collateral_value,
        cs.total_collateral,
        {{ safe_divide('cs.total_value', 'l.outstanding_balance') }} as collateral_coverage_ratio,
        case
            when l.classification in ('Substandard', 'Doubtful', 'Loss')
            then 1 else 0
        end as is_non_performing
    from loans l
    left join classifications c on l.classification = c.classification
    left join collateral_summary cs on l.loan_id = cs.loan_id
)
select * from final