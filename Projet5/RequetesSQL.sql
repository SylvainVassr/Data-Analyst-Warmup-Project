-- 1. Fournissez une requête affichant les Clients (leurs noms complets, ID client et pays) qui ne sont pas aux États-Unis.
select first_name, last_name, customer_id, country 
from customer
where country <> 'USA'
-- Plusieurs facon de dire différent : != , NOT IN('USA')

-- 2. Fournissez une requête affichant uniquement les Clients provenant du Brésil.
select first_name, last_name, customer_id, country 
from customer
where country = 'Brazil'

-- 3. Fournissez une requête affichant les factures des clients qui sont du Brésil.
select first_name, last_name, invoice_id, invoice_date, billing_country
from customer c, invoice i
where c.customer_id = i.customer_id
and country = 'Brazil'

-- 4. Fournissez une requête affichant uniquement les employés qui sont des Agents de Vente
select last_name, first_name    
from employee e 
where title  = 'Sales Support Agent'
-- Légère ambiguïté concernant le titre exact des agents de vente dans la consigne

-- 5. Fournissez une requête affichant une liste unique des pays de facturation présents dans la table Invoice.
select distinct billing_country	
from invoice i

-- 6. Fournissez une requête affichant les factures associées à chaque agent de vente.
select e.last_name, e.first_name, invoice_id
from invoice i, customer c, employee e
where i.customer_id = c.customer_id
and c.support_rep_id = e.employee_id 
order by e.last_name

-- 7. Fournissez une requête affichant le total de chaque facture, le nom du client, le pays et le nom de l'agent de vente.
select total, c.last_name, c.country, e.last_name
from invoice i, customer c, employee e
where i.customer_id = c.customer_id
and c.support_rep_id = e.employee_id 
order by e.last_name

-- 8. Combien de factures y a-t-il eu en 2009 et 2011 ?
-- Auncune données pour les années voulus. Nous regarderons pour 2021 et 2025

select 	DATE_PART('year', invoice_date) as annee, 
		count(*) as nb_invoice, 
		sum(total) as total_invoice
from invoice
where DATE_PART('year', invoice_date) in (2021, 2025)
group by annee 

-- Ajout d'alias pour une meilleure lecture

-- 9. Fournissez une requête comptant le nombre d'articles (line items) pour l'ID de facture 37.

select count(invoice_id) as Nb_article
from invoice_line il 
where il.invoice_id = 37

-- 10.  Fournissez une requête comptant le nombre d'articles (line items) pour chaque facture.

select invoice_id as ID_Facture, count(invoice_id) as Nb_article
from invoice_line il
group by invoice_id 

-- 11. Fournissez une requête incluant le nom du morceau pour chaque ligne de facture.

select il.invoice_id as ID_Facture, "name"
from invoice_line il, track t 
where il.track_id = t.track_id
order by ID_Facture

-- 12. Fournissez une requête incluant le nom du morceau acheté ET le nom de l'artiste pour chaque ligne de facture.
-- Utilisation des jointures a l'aide des mots clés prévus pour une meilleur lisibilité

--v1
select il.invoice_id as ID_Facture, t."name", a2."name"
from invoice_line il, track t, album a, artist a2 
where il.track_id = t.track_id
and t.album_id = a.album_id
and a.artist_id = a2.artist_id
order by ID_Facture

--v2
select il.invoice_id as ID_Facture, t."name", a2."name"
from invoice_line il 
inner join track t on il.track_id = t.track_id
inner join album a on t.album_id = a.album_id
inner join artist a2 on a.artist_id = a2.artist_id
order by ID_Facture

-- 13. Fournissez une requête affichant le nombre de factures par pays.

select sum(il.invoice_id), i.billing_country as Nb_Factures
from invoice_line il
inner join invoice i on il.invoice_id = i.invoice_id
group by i.billing_country

-- 14. Fournissez une requête affichant le nombre total de morceaux dans chaque playlist. Le nom de la playlist doit être inclus dans le tableau résultant.
-- right join ici pour afficher tout nos noms de playlist, meme ceux vide

select count(pt.track_id), p."name"
from playlist_track pt
right join playlist p on pt.playlist_id = p.playlist_id 
group by p."name"

-- 15. Liste des morceaux : Fournissez une requête affichant tous les morceaux (Tracks), mais sans afficher les IDs. 
-- Le tableau résultant doit inclure le nom de l'album, le type de média et le genre.

select t."name", a.title, mt."name", g."name"
from track t
left join album a on t.album_id = a.album_id
inner join media_type mt on t.media_type_id = mt.media_type_id
inner join genre g on t.genre_id = g.genre_id

-- L'énonce nous demande tout les morceux, il aurait été plus prudent de faire que des left join afin d'être certain de tous les avoir. 
-- Dans notre cas, cela ne change pas le résultat mais cette négligeance aurait pu.

-- 16. Fournissez une requête affichant toutes les factures, avec le nombre d'articles par facture.

select distinct i.invoice_id as ID_Facture, sum(il.quantity) as Nb_article
from invoice i
inner join invoice_line il on i.invoice_id = il.invoice_id
group by i.invoice_id
order by i.invoice_id

-- 17. Fournissez une requête affichant les ventes totales réalisées par chaque agent de vente.

select e.first_name, e.last_name, e.title, SUM(i.total)
from invoice i
inner join customer c on i.customer_id  = c.customer_id
left join employee e on c.support_rep_id = e.employee_id
--where e.title like 'Sales%'
group by e.first_name, e.last_name, e.title

-- Nous pouvons préciser le title afin d'être sur de n'avoir que des employees dans la vente.

-- 18. Quel agent de vente a réalisé le plus de ventes en 2009 ?
-- Nous changeons l'année pour 2021 car nous n'avons pas de valeur pour l'année 2009

select e.first_name, e.last_name, sum(i.total)
from employee e
inner join customer c on e.employee_id = c.support_rep_id
inner join invoice i on c.customer_id = i.customer_id
where DATE_PART('year', i.invoice_date) in (2021)
group by e.first_name, e.last_name
--order by sum(i.total)

-- Le ORDER BY doit soi faire référence a l'alias soit à la fonction d'agrégation !
-- Il n'est pas indispensable ici, mais dans un volume de données plus important, il pourrait intervenir

-- 19. Quel agent de vente a réalisé le plus de ventes en 2010 ?
-- Nous suivons la logique et passons de 2021 a 2022

select e.first_name, e.last_name, sum(i.total)
from employee e
inner join customer c on e.employee_id = c.support_rep_id
inner join invoice i on c.customer_id = i.customer_id
where DATE_PART('year', i.invoice_date) in (2022)
group by e.first_name, e.last_name

-- 20. Quel agent de vente a réalisé le plus de ventes en tout ?

select e.first_name, e.last_name, sum(i.total)
from employee e
inner join customer c on e.employee_id = c.support_rep_id
inner join invoice i on c.customer_id = i.customer_id
group by e.first_name, e.last_name

-- 21. Fournissez une requête affichant le nombre de clients attribués à chaque agent de vente.

select e.first_name, e.last_name, count(c.customer_id)
from employee e 
inner join customer c on e.employee_id = c.support_rep_id
group by e.first_name, e.last_name


-- 22. Fournissez une requête affichant les ventes totales par pays. Quel pays a dépensé le plus ?

select distinct c.country, sum(i.total) as total
from invoice i 
right join customer c on i.customer_id = c.customer_id
group by c.country
order by total DESC

-- 23. Fournissez une requête affichant le morceau le plus acheté en 2013.
-- On remplace 2013 par 2025

select T."name", sum(il.quantity) as quantity
from track t
inner join invoice_line il on t.track_id = il.track_id
inner join invoice i  on il.invoice_id = i.invoice_id
where DATE_PART('year', i.invoice_date) in (2025)
group by t."name"
order by quantity desc

-- 24. Fournissez une requête affichant les 5 morceaux les plus achetés en tout.

select T."name", sum(il.quantity) as quantity
from track t
inner join invoice_line il on t.track_id = il.track_id
group by t."name"
order by quantity desc
limit 5

-- 25. Fournissez une requête affichant les 3 artistes les plus vendus.

select a."name", sum(il.quantity) as quantity
from artist a
left join album a2 on a.artist_id = a2.artist_id
inner join track t on a2.album_id = t.album_id
inner join invoice_line il  on t.track_id = il.track_id
group by a."name"
order by quantity desc
limit 3

-- 26. Fournissez une requête affichant le type de média le plus acheté.

select mt."name", sum(il.quantity) as quantity
from media_type mt
inner join track t on mt.media_type_id = t.media_type_id
inner join invoice_line il on t.track_id = il.track_id
group by mt."name"
order by quantity desc
