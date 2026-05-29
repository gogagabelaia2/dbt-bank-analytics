{% macro classify_loan_risk(days_past_due, classification) %}

case
    when {{ classification }} in ('Loss', 'Doubtful')
        then 'Critical'
    when {{ days_past_due }} >= 90
        then 'High'
    when {{ classification }} = 'Substandard'
        or {{ days_past_due }} between 30 and 89
        then 'Medium'
    when {{ classification }} = 'Special Mention'
        or {{ days_past_due }} between 1 and 29
        then 'Low'
    else 'Clean'
end

{% endmacro %}