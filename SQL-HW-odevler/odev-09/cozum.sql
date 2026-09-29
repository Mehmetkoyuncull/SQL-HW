/* ============================================================
   Ödev 9 — INNER JOIN
   Veritabanı : dvdrental (PostgreSQL)

   INNER JOIN, iki tabloda da EŞLEŞEN satırları döndürür.
   Eşleşmeyen satırlar sonuca dahil edilmez.
   ============================================================ */


/* ------------------------------------------------------------
   SORU 1
   city ve country tablolarını birleştirip şehir ve ülke
   isimlerini birlikte gösteriniz.

   Bağlantı sütunu: city.country_id = country.country_id
   ------------------------------------------------------------ */
SELECT ci.city,
       co.country
FROM city AS ci
INNER JOIN country AS co
        ON ci.country_id = co.country_id
ORDER BY co.country, ci.city;
-- 600 satır

-- Takma ad (alias) kullanmadan yazılmış hâli:
SELECT city.city,
       country.country
FROM city
INNER JOIN country
        ON city.country_id = country.country_id;

-- Bağlantı sütunlarının adı iki tabloda da aynı olduğu için
-- USING kısayolu da kullanılabilir:
SELECT city, country
FROM city
INNER JOIN country USING (country_id);


/* ------------------------------------------------------------
   SORU 2
   customer ve payment tablolarını birleştirip payment_id ile
   müşterinin adını ve soyadını gösteriniz.

   Bağlantı sütunu: customer.customer_id = payment.customer_id
   ------------------------------------------------------------ */
SELECT p.payment_id,
       c.first_name,
       c.last_name
FROM customer AS c
INNER JOIN payment AS p
        ON c.customer_id = p.customer_id
ORDER BY p.payment_id;
-- 14.596 satır


/* ------------------------------------------------------------
   SORU 3
   customer ve rental tablolarını birleştirip rental_id ile
   müşterinin adını ve soyadını gösteriniz.

   Bağlantı sütunu: customer.customer_id = rental.customer_id
   ------------------------------------------------------------ */
SELECT r.rental_id,
       c.first_name,
       c.last_name
FROM customer AS c
INNER JOIN rental AS r
        ON c.customer_id = r.customer_id
ORDER BY r.rental_id;
-- 16.044 satır
