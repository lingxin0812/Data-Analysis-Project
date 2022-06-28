/* Total order number of each day & total income */
select date(transaction_date) Day, floor(sum(unit_price * quantity)) income,
count(distinct product_id) item_num
from coffeeshop.`sales reciepts` 
group by Day
Order by Day;


/* Customer Analysis */
-- check how many customer who not register loyalt card yet
select count(transaction_id)
from coffeeshop.`sales reciepts`
where customer_id=0;

-- customer who register loyalt card when they first purcahse
select cc.customer_id, transaction_date
from coffeeshop.`sales reciepts` rs
inner join coffeeshop.customer cc
on rs.customer_id = cc.customer_id
where transaction_date = customer_since;

/* Consumption Behavior Analysis of Registered Member */

--  Number of days, total number of orders, and total spending per customer
select customer_id, count(distinct date(transaction_date)) days, count(transaction_id) order_times, floor(sum(unit_price*quantity)) cost
from coffeeshop.`sales reciepts`
where customer_id <>0
group by customer_id
order by cost desc;

-- product preference for each member
select p.product_category, p.product_type, sr.customer_id, count(sr.product_id) ordertimes, floor(sum(unit_price * quantity)) cost
from coffeeshop.`sales reciepts`sr
inner join coffeeshop.product p
on sr.product_id = p.product_id
where customer_id<>0
group by sr.customer_id, p.product_id
order by customer_id;

-- sale outlet preference for each member
select sr.customer_id, sr.sales_outlet_id, count(sr.sales_outlet_id) times, floor(sum(unit_price * quantity)) cost
from coffeeshop.`sales reciepts`sr 
inner join coffeeshop.sales_outlet so
on sr.sales_outlet_id = so.sales_outlet_id
where customer_id<>0
group by sr.customer_id, sr.sales_outlet_id
order by customer_id;

-- Consumption time distribution
select hour(transaction_time) time_hh, count(customer_id) people
from coffeeshop.`sales reciepts`
group by time_hh
order by time_hh;

-- Gender and age of registered member
select sum(if(gender='M',1,0)) Male, sum(if(gender='F',1,0)) Female, sum(if(gender='N',1,0)) Unknow,
		sum(if(age>=20 and age<=30,1,0)) 20to30, sum(if(age>=30 and age<=40,1,0)) 30to40,
        sum(if(age>=40 and age<=50,1,0)) 40to50, sum(if(age>50,1,0)) over50
from (select gender, year(current_date) - birth_year age from coffeeshop.customer) t;