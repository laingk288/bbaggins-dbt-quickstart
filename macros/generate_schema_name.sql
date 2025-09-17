{% macro generate_schema_name(custom_schema_name, node) -%}
  {%- if custom_schema_name is none -%}
    {{ target.schema }}         -- no custom schema specified: use target schema
  {%- else -%}
    {{ custom_schema_name | upper }}  -- use exactly what you set in `schema:` (no prefix)
  {%- endif -%}
{%- endmacro %}
