{% macro risk_flag(columns) %}
case
    {% for col in columns %}
        when {{ col }} is null then 'missing_{{ col }}'
    {% endfor %}
    else 'ok'
end as data_quality_flag
{% endmacro %}