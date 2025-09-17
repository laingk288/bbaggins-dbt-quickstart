{{ config(
    database='RAW',
    schema='DBT_KLAING_MTG',
    materialized='view'
) }}

with src as (
  select
      to_date(date)                as rate_date,
      lower(series)                as series,
      cast(value as float)         as value
  from {{ ref('boc_rates') }}      -- <— use the seed via ref()
)

select * from src;
