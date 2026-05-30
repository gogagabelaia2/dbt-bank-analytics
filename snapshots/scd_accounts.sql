{% snapshot scd_accounts %}

{{
    config(
        target_schema='snapshots',
        unique_key='account_id',
        strategy='timestamp',
        updated_at='created_at'
    )
}}

select
    account_id,
    customer_id,
    branch_id,
    account_type,
    currency,
    balance,
    status,
    created_at
from {{ source('bank_raw', 'accounts') }}

{% endsnapshot %}