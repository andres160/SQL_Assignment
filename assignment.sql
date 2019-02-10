#1a. Display the first and last names of all actors from the table actor.

SELECT first_name, last_name from actor;

#1b. Display the first and last name of each actor in a single column in upper case letters. 
#Name the column Actor Name.

SELECT UPPER(CONCAT(first_name,' ',last_name)) AS 'Actor Name'
FROM actor;

-- #2a. You need to find the ID number, first name, and last name of an actor, 
-- of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

SELECT actor_id, first_name, last_name
from actor
where first_name = "Joe";

#2b. Find all actors whose last name contain the letters GEN:

SELECT first_name, last_name
FROM actor
WHERE last_name LIKE  '%GEN%';

#2c. Find all actors whose last names contain the letters LI.
#This time, order the rows by last name and first name, in that order:

SELECT first_name, last_name
FROM actor
WHERE last_name LIKE  '%LI%'
ORDER BY 2,1;

#2d. Using IN, display the country_id and country columns of the following countries:
#Afghanistan, Bangladesh, and China:

SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor.
-- You don't think you will be performing queries on a description,
-- so create a column in the table actor named description and use the data type BLOB
ALTER TABLE actor
ADD description blob;

#3b. Very quickly you realize that entering descriptions for each actor is too much effort.
#Delete the description column.

ALTER TABLE actor
drop description;

#4a. List the last names of actors, as well as how many actors have that last name.

SELECT last_name, COUNT(*) AS 'Count'
from actor
group by 1;

-- 4b. List last names of actors and the number of actors who have that last name,
-- but only for names that are shared by at least two actors

SELECT last_name, COUNT(*) AS 'Count'
from actor
group by 1
having count >= 2;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
-- Write a query to fix the record.

UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' and last_name = 'WILLIAMS';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO.
-- It turns out that GROUCHO was the correct name after all! In a single query,
-- if the first name of the actor is currently HARPO, change it to GROUCHO.

UPDATE actor 
SET first_name= 'GROUCHO'
WHERE first_name='HARPO' AND last_name='WILLIAMS';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?

DESCRIBE sakila.address;

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member.
#Use the tables staff and address:

SELECT s.first_name, s.last_name, a.address
from staff s 
join address a on a.address_id = s.address_id;

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005.
#Use tables staff and payment.

SELECT s.staff_id AS 'Staff Member',  sum(p.amount) AS 'Total'
from payment p
join staff s on s.staff_id = p.staff_id
group by 1
order by 1 asc;

-- 6c. List each film and the number of actors who are listed for that film.
-- Use tables film_actor and film. Use inner join.

SELECT f.title, count(a.actor_id)
from film f
inner join film_actor a on f.film_id = a.film_id
group by 1;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
#2

-- 6e. Using the tables payment and customer and the JOIN command,
-- list the total paid by each customer. List the customers alphabetically by last name:

SELECT c.first_name, c.last_name, sum(p.amount) as 'total spent'
from customer c
join payment p on c.customer_id = p.customer_id
group by 1, 2
order by 2;

#7a

SELECT title
FROM film
WHERE (title LIKE 'K%' OR title LIKE 'Q%') 
AND language_id=(SELECT language_id FROM language where name='English');

#7b

SELECT first_name, last_name
FROM actor
WHERE actor_id
	IN (SELECT actor_id FROM film_actor WHERE film_id 
		IN (SELECT film_id from film where title='ALONE TRIP'));

-- 7c

SELECT first_name, last_name, email 
FROM customer cu
JOIN address a ON (cu.address_id = a.address_id)
JOIN city cit ON (a.city_id=cit.city_id)
JOIN country cntry ON (cit.country_id=cntry.country_id);

-- 7d

SELECT title from film f
JOIN film_category fcat on (f.film_id=fcat.film_id)
JOIN category c on (fcat.category_id=c.category_id);

-- 7e

SELECT title, COUNT(f.film_id) AS 'Count_of_Rented_Movies'
FROM  film f
JOIN inventory i ON (f.film_id= i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
GROUP BY title ORDER BY Count_of_Rented_Movies DESC;

-- 7f

SELECT s.store_id, SUM(p.amount) 
FROM payment p
JOIN staff s ON (p.staff_id=s.staff_id)
GROUP BY store_id;

-- 7g

SELECT store_id, city, country FROM store s
JOIN address a ON (s.address_id=a.address_id)
JOIN city c ON (a.city_id=c.city_id)
JOIN country cntry ON (c.country_id=cntry.country_id);
-- 
-- 7h

SELECT c.name AS "Top Five", SUM(p.amount) AS "Gross" 
FROM category c
JOIN film_category fc ON (c.category_id=fc.category_id)
JOIN inventory i ON (fc.film_id=i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
JOIN payment p ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;

-- 8a

SELECT c.name AS "Top Five", SUM(p.amount) AS "Gross" 
FROM category c
JOIN film_category fc ON (c.category_id=fc.category_id)
JOIN inventory i ON (fc.film_id=i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
JOIN payment p ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;

-- 8b. How would you display the view that you created in 8a?

SELECT* FROM TopFive;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW TopFive;

