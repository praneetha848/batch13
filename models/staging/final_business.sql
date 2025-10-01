{{config(materialized='table',
        transient='false')}}

with customers as (
  select
  cust_id as customer_id,
   name,
   surname from {{ref('customers')}}

),

orders as (
    select
    id as order_id,
    user_id as customer_id,
    order_date,
    status
from {{source('datafeed_shared_schema','raw_order')}}

),

customer_orders as (

 select
customer_id,
min(order_date) as first_order_date,
max(order_date) as most_recent_order_date,
count(order_id) as number_of_orders
 from orders
group by 1

),

final as (

select
customers.customer_id,
customers.name,
customers.surname,
customer_orders.first_order_date,
customer_orders.most_recent_order_date,
coalesce(customer_orders.number_of_orders, 0) as number_of_orders
from customers
left join customer_orders using (customer_id)
)

select * from final
