create database customer_behaviour;

use customer_behaviour;

select * from customer limit 10;

-- Total revenue by male and female 
select gender, sum(purchase_amount) as Total_Revenue from customer
group by gender;

-- customer who used discount but still purchased more than avg amount 
select * from customer limit 10;

select avg(purchase_amount) from customer;

select customer_id,sum(purchase_amount),discount_applied as 'Revenue' from customer 
where discount_applied='Yes'
group by customer_id 
having sum(purchase_amount)> (select avg(purchase_amount) from customer);

-- Top 5 products with highest average review rating 
select * from customer limit 10;

select  item_purchased , round(avg(review_rating),2) as "average_rating" from customer group by item_purchased
order by 2 desc limit 5 ;
 
 -- compare average purchase amount between standard and express shipping 
select shipping_type, avg(purchase_amount) as 'average_amount'
 from customer
 where shipping_type ='Express'
 union 
 select shipping_type, avg(purchase_amount) as 'average_amount'
 from customer
 where shipping_type ='Standard';

select shipping_type, avg(purchase_amount) as 'average_amount'
 from customer
 where shipping_type in ('Express','Standard')
 group by shipping_type;

-- Does subsribed customer spend more than non subscriber? compare average spend and total revenue 

select subscription_status ,
count(customer_id) as "Total_Customers",
Round(avg(purchase_amount),2) as "average_amount", 
Round(sum(purchase_amount),2) as "Total_Revenue"
from customer group by subscription_status
 order by 3,2 ;
 
 -- which 5 products have highest precenatge of purchases with diccount apppled 
 select item_purchased, 
 (sum(purchase_amount)/(select sum(purchase_amount) from customer))*100 as "Revenue_percentage" 
 from customer
 where discount_applied='Yes'
 group by item_purchased
 order by 2 desc
 limit 5;
 
 select item_purchased, 
 Round(100*sum(case when discount_applied='Yes' then 1 else 0 end)/count(*),2) as "purchase_percentage"
from customer 
group by item_purchased
order by 2 desc
 limit 5;
 
 -- segment customers into new, returning, Loyal , based on previous purchaes 
 select * from customer;
 
 with CTE as 
 (
 select customer_id, previous_purchases,
 case when previous_purchases =1 then "NEW"
 when  previous_purchases >=2 and  previous_purchases <=10 then "Returning"
 when previous_purchases>10 then "Loyal"
 end as "Customer_order_segment"
 from customer
 )
 select customer_order_segment,count(*) as "customer_type_cont" from CTE
 group by customer_order_segment ; 
 
 -- Top 3 most purchased product within each category 
 select * from customer limit 10;
 
with CTE as 
(
 select category,item_purchased,count(customer_id) as "Purchase_count",
 ROW_NUMBER() over (partition by category order by count(customer_id) desc) as "rnk"
 from customer 
 group by category, item_purchased
 )
 select category,
 item_purchased,
 purchase_count
 from CTE 
 where rnk<=3;
 
select * from customer;

-- Are repeat customers also subscribers?

select subscription_status,count(customer_id) as "customer_count"
from customer where previous_purchases>5
group by subscription_status;

-- Revenue by age group

select * from customer;

select age_group,sum(purchase_amount) as "Total_Revenue" from customer
group by age_group
order by sum(purchase_amount) desc;
