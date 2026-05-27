{% macro classify_customer_type(customer_type) %}
case
    when{{customer_type}} in ('vip','premium') then 'High Value'
    when {{customer_type}} in ('corporate','sme') then 'Business'
    else 'Standard'
end
{% endmacro %}