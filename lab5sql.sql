##1 Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT i.film_id, COUNT(*) AS row_count,f.title
FROM inventory i
INNER JOIN 
(SELECT title,film_id  FROM film
WHERE title LIKE "Hunchback Impossible") f
ON f.film_id=i.film_id;
##2 List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film);
#3 Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT *
FROM actor a
INNER JOIN  film_actor fa
		ON a.actor_id=fa.actor_id
INNER JOIN 
			(SELECT title,film_id FROM film
			WHERE title LIKE "Alone Trip") f
		on f.film_id=fa.film_id;


#4 Sales have been lagging among young families, and you want to target family movies for a promotion. 
# Identify all movies categorized as family films.
SELECT f.title, f.film_id 
FROM film f
INNER JOIN film_category f_c ON f.film_id = f_c.film_id
INNER JOIN (
    SELECT category_id, name 
    FROM category
    WHERE name LIKE 'Family'
) c ON f_c.category_id = c.category_id;



#5 Retrieve the name and email of customers from Canada using both subqueries and joins.
#To use joins, you will need to identify the relevant tables and their primary and foreign keys.

SELECT CONCAT(first_name," ",last_name), c.email,country  
FROM customer c
INNER JOIN address a 
		ON c.address_id=a.address_id
			INNER JOIN city ci
              ON ci.city_id=a.city_id
						INNER JOIN (
							SELECT * FROM  country
                            WHERE country LIKE "Canada")co 
                        
                        ON ci.country_id=co.country_id ;
                        


#6 Determine which films were starred by the most prolific actor in the Sakila database. 
#A prolific actor is defined as the actor who has acted in the most number of films.
#First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
SELECT * FROM film;

SELECT actor_id, COUNT(film_id) AS row_count
FROM film_actor
GROUP BY actor_id
ORDER BY COUNT(film_id) DESC
LIMIT 1;


SELECT * FROM film f
INNER JOIN 
(SELECT film_id FROM film_actor
WHERE actor_id= 107) cc
		ON cc.film_id=f.film_id


#7 Find the films rented by the most profitable customer in the Sakila database. 
#You can use the customer and payment tables to find the most profitable customer, i.e., 
# the customer who has made the largest sum of payments.

SELECT f.title, f.film_id
FROM film f
INNER JOIN inventory i 
		ON f.film_id = i.film_id
INNER JOIN rental r
		ON i.inventory_id = r.inventory_id
INNER JOIN payment p 
		ON r.customer_id = p.customer_id
WHERE p.customer_id = (
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 1;


#8 Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. 
#You can use subqueries to accomplish this.