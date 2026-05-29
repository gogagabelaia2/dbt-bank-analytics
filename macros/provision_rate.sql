{% macro provision_rate(days_past_due) %}
    case
        when {{ days_past_due }} = 0    then 0.01
        when {{ days_past_due }} <= 30  then 0.05
        when {{ days_past_due }} <= 90  then 0.20
        else  0.50
    end
{% endmacro %}
