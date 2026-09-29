/* ============================================================
   Ödev 7 — GROUP BY ve HAVING
   Veritabanı : dvdrental (PostgreSQL)

   Sorgu çalışma sırası:
     FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY -> LIMIT

   WHERE  : gruplama ÖNCESİ tek tek satırları filtreler
   HAVING : gruplama SONRASI grupları filtreler
   ============================================================ */


/* ------------------------------------------------------------
   SORU 1
   Filmleri rating değerlerine göre gruplayınız.
   ------------------------------------------------------------ */
SELECT rating,
       count(*) AS film_sayisi
FROM film
GROUP BY rating
ORDER BY film_sayisi DESC;


/* ------------------------------------------------------------
   SORU 2
   replacement_cost'a göre gruplandığında film sayısı 50'den
   FAZLA olan replacement_cost değerleri ve film sayıları.

   Grup üzerinde koşul olduğu için WHERE değil HAVING kullanılır.
   ------------------------------------------------------------ */
SELECT replacement_cost,
       count(*) AS film_sayisi
FROM film
GROUP BY replacement_cost
HAVING count(*) > 50
ORDER BY film_sayisi DESC;
-- 8 grup


/* ------------------------------------------------------------
   SORU 3
   store_id değerlerine karşılık gelen müşteri sayıları.
   ------------------------------------------------------------ */
SELECT store_id,
       count(*) AS musteri_sayisi
FROM customer
GROUP BY store_id
ORDER BY store_id;


/* ------------------------------------------------------------
   SORU 4
   country_id'ye göre gruplandığında en fazla şehir barındıran
   country_id ve şehir sayısı.

   En fazla -> sayıya göre AZALAN sıralama + LIMIT 1
   ------------------------------------------------------------ */
SELECT country_id,
       count(*) AS sehir_sayisi
FROM city
GROUP BY country_id
ORDER BY sehir_sayisi DESC
LIMIT 1;
-- country_id = 44, 60 şehir

-- Ülke adını da görmek için country tablosu ile birleştirilmiş hâli:
SELECT ci.country_id,
       co.country,
       count(*) AS sehir_sayisi
FROM city ci
JOIN country co ON co.country_id = ci.country_id
GROUP BY ci.country_id, co.country
ORDER BY sehir_sayisi DESC
LIMIT 1;
-- country_id = 44, India, 60 şehir
