/* ============================================================
   Ödev 2 — BETWEEN ve IN Operatörleri
   Veritabanı : dvdrental (PostgreSQL)
   ============================================================ */


/* ------------------------------------------------------------
   SORU 1
   replacement_cost 12.99'dan büyük eşit ve 16.99'dan küçük.
   BETWEEN - AND yapısı kullanılacak.

   DİKKAT: BETWEEN her iki sınırı da DAHİL eder, yani
   BETWEEN 12.99 AND 16.99  ==  replacement_cost >= 12.99
                                AND replacement_cost <= 16.99
   ------------------------------------------------------------ */
SELECT *
FROM film
WHERE replacement_cost BETWEEN 12.99 AND 16.99;
-- 236 satır

-- Soru metnindeki "16.99'dan küçük" (16.99 hariç) koşulu birebir
-- isteniyorsa üst sınır bir alt değere çekilir:
SELECT *
FROM film
WHERE replacement_cost BETWEEN 12.99 AND 15.99;
-- 198 satır  (= replacement_cost >= 12.99 AND replacement_cost < 16.99)


/* ------------------------------------------------------------
   SORU 2
   actor tablosundan first_name 'Penelope', 'Nick' veya 'Ed'
   olan kayıtların first_name ve last_name değerleri.
   IN operatörü kullanılacak.
   ------------------------------------------------------------ */
SELECT first_name,
       last_name
FROM actor
WHERE first_name IN ('Penelope', 'Nick', 'Ed');
-- 10 satır

-- IN olmadan aynı sonuç (IN, OR zincirinin kısa yazımıdır):
SELECT first_name,
       last_name
FROM actor
WHERE first_name = 'Penelope'
   OR first_name = 'Nick'
   OR first_name = 'Ed';


/* ------------------------------------------------------------
   SORU 3
   rental_rate 0.99, 2.99, 4.99 VE
   replacement_cost 12.99, 15.99, 28.99 olma koşulları.
   IN operatörü kullanılacak.
   ------------------------------------------------------------ */
SELECT *
FROM film
WHERE rental_rate      IN (0.99, 2.99, 4.99)
  AND replacement_cost IN (12.99, 15.99, 28.99);
-- 133 satır
