#Qus-1-Find customer who have never order any dish
select name 
from users 
where user_id 
not in (select user_id from orders);


#qus-2- Average price per dish
SELECT f_id,AVG(price) from menu group by(f_id);

use zomato;
SELECT name FROM users WHERE user_id NOT IN (SELECT user_id FROM orders);

#Qus-3-Find top restaurant in term of number of orders for a given month
select r.r_name,count(*) 
as 'total_orders' 
from orders o
join restaurants r
on o.r_id=r.r_id
where monthname(o.date) = 'june'
group by r.r_id, r.r_name
order by total_orders desc limit 1;



#Qus-4- Restaurants with monthly sales > x for

SELECT 
    r.r_name,  
    SUM(o.amount) AS revenue
FROM orders o
JOIN restaurants r ON o.r_id = r.r_id
WHERE MONTHNAME(o.date) = 'June'
GROUP BY r.r_id, r.r_name
HAVING revenue > 500;

#Qus-5- Show all orders with order details for a particular customer in a particular date range
select o.order_id,r.r_name, f.f_name 
from orders o
join restaurants  r
on r.r_id=o.r_id 
join order_details od
on o.order_id=od.order_id
join food f
on f.f_id=od.f_id
where user_id= (select user_id from users where name like 'Ankit')
and (date >'2022-06-10' and date< '2022-07-10');

#Qus-6- Find the restaurant with maximum repeated customer

select r.r_name, count(*) as 'loyal_customers'
from(
	select r_id, user_id, count(*) as 'visits'
    from orders
    group by r_id, user_id
    having visits>1
) t
join restaurants r
on r.r_id=t.r_id
group by r.r_name
order by loyal_customers 
desc limit 1;

#Qus-7- Month over month revenue growth of swiggy
select month,((revenue-prev)/prev)*100 as rev_growth from(
	with sales as
    (
	select   monthname(date) as 'month', sum(amount) as 'revenue' 
	from orders
	group by month(date), monthname(date)
	order by month(date)
    )

select month, revenue, lag(revenue,1) over(order by revenue) as prev from sales
) t;

#Qus-8- customers favourite food with their name
with temp as (
	select o.user_id,od.f_id,count(*) as frequency
	from orders o
	join order_details od
	on o.order_id=od.order_id
	group by o.user_id, od.f_id
)
select u.name, f.f_name from
temp t1 
join users u
on u.user_id=t1.user_id
join food f
on f.f_id=t1.f_id
where t1.frequency = (
	select max(frequency) 
    from temp t2 
    where t2.user_id=t1.user_id);





