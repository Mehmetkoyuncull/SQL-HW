/* ============================================================
   Ödev 10 — LEFT / RIGHT / FULL JOIN (OUTER JOIN'ler)
   Veritabanı : dvdrental (PostgreSQL)

   LEFT  JOIN -> sol tablonun TÜM satırları + eşleşen sağ satırlar
   RIGHT JOIN -> sağ tablonun TÜM satırları + eşleşen sol satırlar
   FULL  JOIN -> her iki tablonun TÜM satırları

   Eşleşme bulunamayan taraf NULL ile doldurulur.
   (OUTER kelimesi opsiyoneldir: LEFT JOIN = LEFT OUTER JOIN)
   ============================================================ */


/* ------------------------------------------------------------
   SORU 1
   city ve country tabloları için LEFT JOIN.

   Sol tablo city olduğu için: ülkesi eşleşmeyen şehirler de
   sonuca dahil olur, country sütunu NULL gelir.
   ------------------------------------------------------------ */
SELECT ci.city,
       co.country
FROM city AS ci
LEFT JOIN country AS co
       ON ci.country_id = co.country_id
ORDER BY co.country NULLS LAST, ci.city;
-- 600 satır

-- Eşleşmeyen (ülkesi olmayan) şehir var mı? -> 0 satır döner
SELECT ci.city, ci.country_id
FROM city AS ci
LEFT JOIN country AS co
       ON ci.country_id = co.country_id
WHERE co.country_id IS NULL;


/* ------------------------------------------------------------
   SORU 2
   customer ve payment tabloları için RIGHT JOIN.

   Sağ tablo payment olduğu için: müşterisi eşleşmeyen ödemeler
   de sonuca dahil olur, first_name / last_name NULL gelir.
   ------------------------------------------------------------ */
SELECT p.payment_id,
       c.first_name,
       c.last_name
FROM customer AS c
RIGHT JOIN payment AS p
        ON c.customer_id = p.customer_id
ORDER BY p.payment_id;
-- 14.596 satır

-- Aynı sonuç, tabloların yeri değiştirilip LEFT JOIN ile:
SELECT p.payment_id,
       c.first_name,
       c.last_name
FROM payment AS p
LEFT JOIN customer AS c
       ON c.customer_id = p.customer_id;


/* ------------------------------------------------------------
   SORU 3
   customer ve rental tabloları için FULL JOIN.

   Her iki tablonun tüm satırları döner; eşleşmeyen taraf
   NULL ile doldurulur.
   ------------------------------------------------------------ */
SELECT r.rental_id,
       c.first_name,
       c.last_name
FROM customer AS c
FULL JOIN rental AS r
       ON c.customer_id = r.customer_id
ORDER BY r.rental_id NULLS LAST;
-- 16.044 satır

-- Hiç kiralama yapmamış müşteri veya müşterisiz kiralama var mı?
SELECT count(*) AS eslesmeyen_satir
FROM customer AS c
FULL JOIN rental AS r
       ON c.customer_id = r.customer_id
WHERE c.customer_id IS NULL
   OR r.rental_id IS NULL;
-- 0


/* ------------------------------------------------------------
   EK: JOIN türleri arasındaki farkı gösteren küçük örnek

   Bu veritabanında yabancı anahtarlar eksiksiz olduğu için
   LEFT/RIGHT/FULL JOIN sonuçları INNER JOIN ile aynı çıkıyor.
   Farkı görmek için kasıtlı olarak eşleşmeyen satırlar
   içeren iki küçük tablo kuralım.
   ------------------------------------------------------------ */
WITH sol(id, ad)    AS (VALUES (1,'A'), (2,'B'), (3,'C')),
     sag(id, deger) AS (VALUES (2,'X'), (3,'Y'), (4,'Z'))
SELECT 'INNER' AS join_turu, sol.id AS sol_id, sol.ad, sag.id AS sag_id, sag.deger
FROM sol INNER JOIN sag ON sol.id = sag.id
UNION ALL
SELECT 'LEFT',  sol.id, sol.ad, sag.id, sag.deger
FROM sol LEFT  JOIN sag ON sol.id = sag.id
UNION ALL
SELECT 'RIGHT', sol.id, sol.ad, sag.id, sag.deger
FROM sol RIGHT JOIN sag ON sol.id = sag.id
UNION ALL
SELECT 'FULL',  sol.id, sol.ad, sag.id, sag.deger
FROM sol FULL  JOIN sag ON sol.id = sag.id
ORDER BY join_turu, sol_id NULLS LAST, sag_id NULLS LAST;
