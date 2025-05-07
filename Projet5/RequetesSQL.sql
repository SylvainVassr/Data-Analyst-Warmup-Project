select first_name, last_name, customer_id, country 
from customer
where country <> 'USA'
-- Plusieurs facon de dire différent : != , NOT IN('USA')

select first_name, last_name, customer_id, country 
from customer
where country = 'Brazil'

select first_name, last_name, invoice_id, invoice_date, billing_country
from customer c, invoice i
where c.customer_id = i.customer_id
and country = 'Brazil'

select last_name, first_name    
from employee e 
where title  = 'Sales Support Agent'
-- Légère ambiguïté concernant le titre exact des agents de vente dans la consigne