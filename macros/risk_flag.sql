{% macro dpd_bucket(days_past_due) %}
case
    when {{ days_past_due }} = 0 then 'performing'
    when {{ days_past_due }} between 1 and 30 then 'watch'
    when {{ days_past_due }} between 31 and 90 then 'substandard'
    when {{ days_past_due }} > 90 then 'non_performing'
   end
{% endmacro %}