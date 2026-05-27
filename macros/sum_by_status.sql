{% macro sum_by_status(status_column, amount_column, statuses) %}
    {% for status in statuses %}
        sum(
            case when {{ status_column }} = '{{ status }}'
            then {{ amount_column }} else 0 end
        ) as {{ amount_column }}_{{ status | lower | replace(' ', '_') }}
        {% if not loop.last %},{% endif %}
    {% endfor %}
{% endmacro %}