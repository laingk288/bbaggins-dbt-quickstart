-- tests/assert_positive_value_for_total_amount.sql
--returns 0 rows when ok 
select 1
from {{ ref('stg_stripe_payments') }}
where status = 'success'
  and amount < 0 --zeros are ok now 

