/* ============================================================
   Ödev 4 — DISTINCT ve COUNT
   Veritabanı : dvdrental (PostgreSQL)
   ============================================================ */


/* ------------------------------------------------------------
   SORU 1
   replacement_cost sütunundaki birbirinden farklı değerler.
   ------------------------------------------------------------ */
SELECT DISTINCT replacement_cost
FROM film
ORDER BY replacement_cost;
-- 21 satır (9.99 ... 29.99, birer birer artıyor)


/* ------------------------------------------------------------
   SORU 2
   replacement_cost sütununda kaç farklı değer var?
   ------------------------------------------------------------ */
SELECT count(DISTINCT replacement_cost) AS farkli_deger_sayisi
FROM film;
-- 21

-- DİKKAT: count(*) ile karıştırılmamalı.
--   count(*)                       -> 1000 (tüm satırlar)
--   count(replacement_cost)        -> 1000 (NULL olmayan satırlar)
--   count(DISTINCT replacement_cost) -> 21 (farklı değerler)


/* ------------------------------------------------------------
   SORU 3
   title 'T' ile başlayan VE rating = 'G' olan film sayısı.
   ------------------------------------------------------------ */
SELECT count(*) AS film_sayisi
FROM film
WHERE title LIKE 'T%'
  AND rating = 'G';
-- 9


/* ------------------------------------------------------------
   SORU 4
   Tam 5 karakterden oluşan ülke isimlerinin sayısı.

   '_____' deseni: tam olarak 5 karakter (5 adet alt çizgi).
   ------------------------------------------------------------ */
SELECT count(*) AS ulke_sayisi
FROM country
WHERE country LIKE '_____';
-- 13

-- length() ile eşdeğer yazım:
SELECT count(*) AS ulke_sayisi
FROM country
WHERE length(country) = 5;


/* ------------------------------------------------------------
   SORU 5
   'R' veya 'r' ile biten şehir isimlerinin sayısı.

   Büyük/küçük harf farkı aranmadığı için ILIKE kullanıldı.
   ------------------------------------------------------------ */
SELECT count(*) AS sehir_sayisi
FROM city
WHERE city ILIKE '%r';
-- 33

-- ILIKE kullanmadan, iki koşulu OR ile bağlayan eşdeğeri:
SELECT count(*) AS sehir_sayisi
FROM city
WHERE city LIKE '%R'
   OR city LIKE '%r';
