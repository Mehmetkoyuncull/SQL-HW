/* ============================================================
   Ödev 5 — ORDER BY, LIMIT ve OFFSET
   Veritabanı : dvdrental (PostgreSQL)

   ORDER BY ... ASC  -> artan (varsayılan)
   ORDER BY ... DESC -> azalan
   LIMIT n           -> ilk n satırı al
   OFFSET m          -> ilk m satırı atla
   ============================================================ */


/* ------------------------------------------------------------
   SORU 1
   'n' ile biten filmlerden en UZUN 5 tanesi.

   En uzun -> length'e göre AZALAN sıralama + LIMIT 5
   ------------------------------------------------------------ */
SELECT *
FROM film
WHERE title LIKE '%n'
ORDER BY length DESC
LIMIT 5;


/* ------------------------------------------------------------
   SORU 2
   'n' ile biten filmlerden en KISA ikinci 5 tanesi,
   yani 6., 7., 8., 9. ve 10. sıradakiler.

   En kısa -> length'e göre ARTAN sıralama
   İlk 5'i atla  -> OFFSET 5
   Sonraki 5'i al -> LIMIT 5
   ------------------------------------------------------------ */
SELECT *
FROM film
WHERE title LIKE '%n'
ORDER BY length ASC
LIMIT 5 OFFSET 5;

-- DİKKAT: length değerinde eşitlik (beraberlik) olduğunda sıralama
-- belirsizleşir. Her çalıştırmada aynı sonucu almak için ikincil bir
-- sıralama sütunu eklenmelidir:
SELECT *
FROM film
WHERE title LIKE '%n'
ORDER BY length ASC, film_id ASC
LIMIT 5 OFFSET 5;


/* ------------------------------------------------------------
   SORU 3
   store_id = 1 olan müşteriler, last_name'e göre AZALAN
   sıralamada ilk 4 kayıt.
   ------------------------------------------------------------ */
SELECT *
FROM customer
WHERE store_id = 1
ORDER BY last_name DESC
LIMIT 4;
