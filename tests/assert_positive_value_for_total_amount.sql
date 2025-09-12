-- tests/assert_positive_value_for_total_amount.sql
select *
from {{ ref('stg_stripe__payment') }}
where total_amount < 0
