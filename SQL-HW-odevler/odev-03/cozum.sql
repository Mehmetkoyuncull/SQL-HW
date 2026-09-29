/* ============================================================
   Ödev 3 — LIKE / ILIKE ve Joker Karakterler
   Veritabanı : dvdrental (PostgreSQL)

   Joker karakterler:
     %  -> sıfır veya daha fazla karakter
     _  -> tam olarak bir karakter
   LIKE  : büyük/küçük harfe duyarlı
   ILIKE : büyük/küçük harfe duyarsız (PostgreSQL'e özgü)
   ============================================================ */


/* ------------------------------------------------------------
   SORU 1
   'A' ile başlayıp 'a' ile biten ülke isimleri.
   ------------------------------------------------------------ */
SELECT country
FROM country
WHERE country LIKE 'A%a';
-- 8 satır


/* ------------------------------------------------------------
   SORU 2
   En az 6 karakterden oluşan ve 'n' ile biten ülke isimleri.

   '_____%n' deseninin okunuşu:
     _____ -> herhangi 5 karakter (zorunlu)
     %     -> 0 veya daha fazla karakter
     n     -> son karakter 'n'
   Toplam en az 5 + 1 = 6 karakter.
   ------------------------------------------------------------ */
SELECT country
FROM country
WHERE country LIKE '_____%n';
-- 12 satır

-- Aynı sonuç, length() fonksiyonu ile daha okunur hâli:
SELECT country
FROM country
WHERE country LIKE '%n'
  AND length(country) >= 6;


/* ------------------------------------------------------------
   SORU 3
   İçinde en az 4 adet 'T' / 't' bulunan film isimleri.

   '%t%t%t%t%' deseni: aralarında herhangi karakter olabilecek
   şekilde en az 4 kez 't' geçmesini şart koşar.
   Büyük/küçük harf farkı olmaması için ILIKE kullanıldı.
   ------------------------------------------------------------ */
SELECT title
FROM film
WHERE title ILIKE '%t%t%t%t%';
-- 9 satır

-- Kontrol amaçlı: her başlıktaki 't' sayısını da gösteren hâli
SELECT title,
       length(title) - length(replace(lower(title), 't', '')) AS t_sayisi
FROM film
WHERE title ILIKE '%t%t%t%t%'
ORDER BY t_sayisi DESC, title;


/* ------------------------------------------------------------
   SORU 4
   title 'C' ile başlayan VE length > 90 VE rental_rate = 2.99
   ------------------------------------------------------------ */
SELECT *
FROM film
WHERE title LIKE 'C%'
  AND length > 90
  AND rental_rate = 2.99;
-- 20 satır
