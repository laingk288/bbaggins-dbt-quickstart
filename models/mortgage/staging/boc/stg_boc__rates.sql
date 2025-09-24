with src as (
  select * from {{ ref('base_boc__rates') }}
),

renamed as (
  select
    observation_date                                   as rate_date,
    upper(series)                                      as series_code,
    value                                              as rate_value_raw,
    nullif(upper(currency), '')                        as currency_code,
    nullif(upper(tenor), '')                           as tenor_code
  from src
),

typed as (
  select
    rate_date,
    series_code,
    -- keep as decimal (e.g., 4.95%) and also provide a fraction (0.0495)
    rate_value_raw::decimal(9,4)                       as rate_percent,
    (rate_value_raw/100.0)::decimal(12,6)              as rate_fraction,
    currency_code,
    tenor_code,
    -- common deriveds
    to_char(rate_date, 'YYYYMMDD')::number(8,0)        as date_key
  from renamed
)

select
  *,
  {{ dbt_utils.generate_surrogate_key(['rate_date','series_code','currency_code','tenor_code']) }} as rates_sk
from typed
