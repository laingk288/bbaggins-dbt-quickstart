{{ config(
    database='RAW',
    schema='DBT_KLAING_MTG',
    materialized='view'
) }}

with ranked as (
  select
    rate_date,
    series,
    value,
    row_number() over (partition by series order by rate_date desc) as rn
  from {{ ref('stg_boc_rates') }}
)
select rate_date, series, value
from ranked
where rn = 1
