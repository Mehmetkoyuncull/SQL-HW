/* ============================================================
   Ödev 6 — Toplama (Aggregate) Fonksiyonları
   Veritabanı : dvdrental (PostgreSQL)

   AVG()   -> ortalama
   COUNT() -> satır / değer sayısı
   MAX()   -> en büyük değer
   MIN()   -> en küçük değer
   SUM()   -> toplam
   ============================================================ */


/* ------------------------------------------------------------
   SORU 1
   rental_rate sütunundaki değerlerin ortalaması.
   ------------------------------------------------------------ */
SELECT avg(rental_rate) AS ortalama_rental_rate
FROM film;
-- 2.9800000000000000

-- Okunabilir çıktı için 2 basamağa yuvarlanmış hâli:
SELECT round(avg(rental_rate), 2) AS ortalama_rental_rate
FROM film;
-- 2.98


/* ------------------------------------------------------------
   SORU 2
   'C' karakteri ile başlayan film sayısı.
   ------------------------------------------------------------ */
SELECT count(*) AS film_sayisi
FROM film
WHERE title LIKE 'C%';
-- 92


/* ------------------------------------------------------------
   SORU 3
   rental_rate = 0.99 olan filmlerin en uzunu kaç dakika?
   ------------------------------------------------------------ */
SELECT max(length) AS en_uzun_dakika
FROM film
WHERE rental_rate = 0.99;
-- 184

-- Bu uzunluğa sahip filmlerin hangileri olduğunu görmek için:
SELECT title, length
FROM film
WHERE rental_rate = 0.99
  AND length = (SELECT max(length) FROM film WHERE rental_rate = 0.99);


/* ------------------------------------------------------------
   SORU 4
   length > 150 olan filmlerde kaç farklı replacement_cost var?
   ------------------------------------------------------------ */
SELECT count(DISTINCT replacement_cost) AS farkli_deger_sayisi
FROM film
WHERE length > 150;
-- 21
