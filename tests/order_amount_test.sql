select
id,
 sum(spent) as total_amount
 from {{source('datafeed_shared_schema','customers')}}
group by 1
having total_amount < 0

