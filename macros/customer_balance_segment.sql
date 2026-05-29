{% macro customer_segment(balance) %}
    CASE 
        WHEN {{ balance }} < 1000                    THEN 'bronze'
        WHEN {{ balance }} BETWEEN 1000 AND 10000    THEN 'silver'
        WHEN {{ balance }} BETWEEN 10000 AND 50000   THEN 'gold'   
        ELSE                                              'platinum'
    END
{% endmacro %}