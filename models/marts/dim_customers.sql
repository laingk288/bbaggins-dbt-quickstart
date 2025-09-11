{{ config(materialized='view') }}

with customers as (
  select id as customer_id, first_name, last_name
  from RAW.JAFFLE_SHOP.CUSTOMERS
),
orders as (
  select id as order_id, user_id as customer_id, order_date
  from RAW.JAFFLE_SHOP.ORDERS
),
payments as (
  select orderid as order_id, status, amount/100.0 as amount
  from RAW.STRIPE.PAYMENT
),
order_payments as (
  select order_id, sum(case when status = 'success' then amount end) as amount
  from payments
  group by order_id
),
orders_enriched as (
  select o.order_id, o.customer_id, o.order_date, coalesce(op.amount, 0) as amount
  from orders o
  left join order_payments op on o.order_id = op.order_id
),
customer_rollup as (
  select
    customer_id,
    min(order_date) as first_order_date,
    max(order_date) as most_recent_order_date,
    count(order_id) as number_of_orders,
    sum(amount) as lifetime_value
  from orders_enriched
  group by customer_id
)
select
  c.customer_id,
  c.first_name,
  c.last_name,
  r.first_order_date,
  r.most_recent_order_date,
  coalesce(r.number_of_orders, 0) as number_of_orders,
  coalesce(r.lifetime_value, 0) as lifetime_value
from customers c
left join customer_rollup r on c.customer_id = r.customer_id




