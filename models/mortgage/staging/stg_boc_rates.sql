{{ config(
    database='RAW',
    schema='DBT_KLAING_MTG',
    materialized='view'
) }}

select
    date,
    series,
    value
from {{ ref('boc_rates') }}
