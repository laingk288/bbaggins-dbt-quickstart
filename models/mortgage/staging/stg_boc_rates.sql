{{ config(materialized='view') }}

select
  date,
  series,
  value
from {{ ref('boc_rates') }}
