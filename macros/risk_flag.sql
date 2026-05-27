{% macro dpd_bucket(days_past_due) %}
case
    when {{ days_past_due }} = 0 then 'Current'
    when {{ days_past_due }} between 1 and 30 then '1-30 DPD'
    when {{ days_past_due }} between 31 and 60 then '31-60 DPD'
    when {{ days_past_due }} between 61 and 90 then '61-90 DPD'
    when {{ days_past_due }} > 90 then '90+ DPD'
    else 'Unknown' 
end
{% endmacro %}