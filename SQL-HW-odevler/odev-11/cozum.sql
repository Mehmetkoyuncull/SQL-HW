/* ============================================================
   Ödev 11 — Küme Operatörleri (UNION / INTERSECT / EXCEPT)
   Veritabanı : dvdrental (PostgreSQL)

   UNION     -> birleşim (A ∪ B)
   INTERSECT -> kesişim  (A ∩ B)
   EXCEPT    -> fark     (A \ B)

   Bu operatörler varsayılan olarak TEKRARLARI SİLER.
   Sonuna ALL eklenirse tekrarlar korunur.

   Kural: iki SELECT'in sütun sayısı ve veri tipleri uyumlu olmalı.
   ============================================================ */


/* ============================================================
   1-3. SORULAR — Tekrarların silindiği hâl (DISTINCT davranış)
   ============================================================ */

/* ------------------------------------------------------------
   SORU 1 — Tüm veriler (birleşim)
   ------------------------------------------------------------ */
SELECT first_name FROM actor
UNION
SELECT first_name FROM customer
ORDER BY first_name;
-- 647 satır


/* ------------------------------------------------------------
   SORU 2 — Kesişen veriler
   Hem oyuncu hem müşteri isimlerinde geçen adlar.
   ------------------------------------------------------------ */
SELECT first_name FROM actor
INTERSECT
SELECT first_name FROM customer
ORDER BY first_name;
-- 72 satır


/* ------------------------------------------------------------
   SORU 3 — İlk tabloda olup ikincide olmayanlar (fark)
   Oyuncularda geçip müşterilerde geçmeyen adlar.
   ------------------------------------------------------------ */
SELECT first_name FROM actor
EXCEPT
SELECT first_name FROM customer
ORDER BY first_name;
-- 56 satır


/* ============================================================
   4. SORU — Aynı üç sorgunun tekrarları koruyan (ALL) hâli
   ============================================================ */

/* ------------------------------------------------------------
   4.1 — UNION ALL
   Tekrarlar silinmez, iki tablonun satırları olduğu gibi
   alt alta eklenir: 200 + 599 = 799
   ------------------------------------------------------------ */
SELECT first_name FROM actor
UNION ALL
SELECT first_name FROM customer
ORDER BY first_name;
-- 799 satır


/* ------------------------------------------------------------
   4.2 — INTERSECT ALL
   Bir değer A'da m kez, B'de n kez geçiyorsa sonuçta
   min(m, n) kez yer alır.
   ------------------------------------------------------------ */
SELECT first_name FROM actor
INTERSECT ALL
SELECT first_name FROM customer
ORDER BY first_name;
-- 72 satır


/* ------------------------------------------------------------
   4.3 — EXCEPT ALL
   Bir değer A'da m kez, B'de n kez geçiyorsa sonuçta
   max(m - n, 0) kez yer alır.
   ------------------------------------------------------------ */
SELECT first_name FROM actor
EXCEPT ALL
SELECT first_name FROM customer
ORDER BY first_name;
-- 128 satır


/* ------------------------------------------------------------
   EK: Sonuçların hangi tablodan geldiğini etiketleyerek
   göstermek istersek (UNION ALL ile):
   ------------------------------------------------------------ */
SELECT 'actor' AS kaynak, first_name FROM actor
UNION ALL
SELECT 'customer', first_name FROM customer
ORDER BY first_name, kaynak;
