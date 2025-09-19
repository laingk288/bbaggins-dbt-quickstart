{{ config(
    database='RAW',
    schema='DBT_KLAING_MTG',
    materialized='table'
) }}

select
  rate_date,
  series,
  value
from {{ ref('int_boc_rates_latest') }}
