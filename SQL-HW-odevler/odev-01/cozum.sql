/* ============================================================
   Ödev 1 — Temel SELECT ve WHERE Sorguları
   Veritabanı : dvdrental (PostgreSQL)
   ============================================================ */


/* ------------------------------------------------------------
   SORU 1
   film tablosunda bulunan title ve description sütunlarındaki
   verileri sıralayınız.
   ------------------------------------------------------------ */
SELECT title,
       description
FROM film;


/* ------------------------------------------------------------
   SORU 2
   film tablosunda bulunan tüm sütunlardaki verileri film
   uzunluğu (length) 60'tan büyük VE 75'ten küçük olma
   koşullarıyla sıralayınız.
   ------------------------------------------------------------ */
SELECT *
FROM film
WHERE length > 60
  AND length < 75;


/* ------------------------------------------------------------
   SORU 3
   film tablosunda bulunan tüm sütunlardaki verileri
   rental_rate 0.99 VE replacement_cost 12.99 VEYA 28.99 olma
   koşullarıyla sıralayınız.

   NOT: rental_rate koşulu her iki replacement_cost değeri için
   de geçerli olmalı; bu yüzden OR koşulu parantez içine alındı.
   SQL'de AND, OR'dan önce çalışır — parantez olmasaydı sorgu
   "(rental_rate=0.99 AND replacement_cost=12.99) OR
    (replacement_cost=28.99)" şeklinde yanlış çalışırdı.
   ------------------------------------------------------------ */
SELECT *
FROM film
WHERE rental_rate = 0.99
  AND (replacement_cost = 12.99 OR replacement_cost = 28.99);

-- Aynı sorgunun IN ile yazılmış hâli:
SELECT *
FROM film
WHERE rental_rate = 0.99
  AND replacement_cost IN (12.99, 28.99);


/* ------------------------------------------------------------
   SORU 4
   customer tablosunda first_name değeri 'Mary' olan müşterinin
   last_name değeri nedir?

   CEVAP: Smith  (customer_id = 1)
   ------------------------------------------------------------ */
SELECT last_name
FROM customer
WHERE first_name = 'Mary';


/* ------------------------------------------------------------
   SORU 5
   film tablosundaki uzunluğu (length) 50'den büyük OLMAYIP
   aynı zamanda rental_rate değeri 2.99 veya 4.99 OLMAYAN
   verileri sıralayınız.
   ------------------------------------------------------------ */
SELECT *
FROM film
WHERE NOT (length > 50)
  AND NOT (rental_rate = 2.99 OR rental_rate = 4.99);

-- Aynı sorgunun NOT kullanılmadan sadeleştirilmiş hâli:
SELECT *
FROM film
WHERE length <= 50
  AND rental_rate NOT IN (2.99, 4.99);
