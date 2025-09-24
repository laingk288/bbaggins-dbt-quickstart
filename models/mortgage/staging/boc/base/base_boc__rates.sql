-- Materialize as view (default) or table if you need heavy transforms
select
  -- keep 1:1 columns but standardize types/whitespace
  try_to_timestamp_ntz(ingested_at) as ingested_at,
  try_to_date(observation_date)     as observation_date,
  trim(series)                      as series,
  try_to_number(value)              as value,
  trim(currency)                    as currency,
  trim(tenor)                       as tenor
from {{ source('boc', 'RATES_RAW') }}
