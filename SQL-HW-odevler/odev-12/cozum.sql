/* ============================================================
   Ödev 12 — Alt Sorgular (Subquery)
   Veritabanı : dvdrental (PostgreSQL)

   Alt sorgu, başka bir sorgunun içinde çalışan SELECT'tir.
   Burada kullanılan tür "skaler alt sorgu"dur: tek satır ve
   tek sütun döndürür, bu yüzden bir değer gibi kullanılabilir.

   Neden gerekli?
     WHERE length > avg(length)   -> HATA
     Toplama fonksiyonları WHERE içinde kullanılamaz; çünkü
     WHERE satır satır çalışırken ortalama henüz hesaplanmamıştır.
     Çözüm: ortalamayı bir alt sorguda önceden hesaplamak.
   ============================================================ */


/* ------------------------------------------------------------
   SORU 1
   Uzunluğu ortalama film uzunluğundan fazla olan film sayısı.
   ------------------------------------------------------------ */
SELECT count(*) AS film_sayisi
FROM film
WHERE length > (SELECT avg(length) FROM film);
-- 489

-- Ortalamayı da görmek için:
SELECT (SELECT round(avg(length), 2) FROM film) AS ortalama_uzunluk,
       count(*) AS ortalamanin_ustundeki_film
FROM film
WHERE length > (SELECT avg(length) FROM film);
-- 115.27 | 489


/* ------------------------------------------------------------
   SORU 2
   En yüksek rental_rate değerine sahip film sayısı.
   ------------------------------------------------------------ */
SELECT count(*) AS film_sayisi
FROM film
WHERE rental_rate = (SELECT max(rental_rate) FROM film);
-- 336  (en yüksek rental_rate = 4.99)


/* ------------------------------------------------------------
   SORU 3
   En düşük rental_rate VE en düşük replacement_cost değerlerine
   sahip filmler.

   İki ayrı skaler alt sorgu AND ile birleştirilir.
   ------------------------------------------------------------ */
SELECT *
FROM film
WHERE rental_rate      = (SELECT min(rental_rate)      FROM film)
  AND replacement_cost = (SELECT min(replacement_cost) FROM film);
-- 15 satır  (rental_rate = 0.99, replacement_cost = 9.99)


/* ------------------------------------------------------------
   SORU 4
   payment tablosunda en fazla sayıda alışveriş yapan müşteriler.

   Adım adım:
     1) Her müşterinin ödeme sayısını bul     -> GROUP BY
     2) Bu sayıların en büyüğünü bul          -> iç içe alt sorgu
     3) Ödeme sayısı bu maksimuma eşit olan
        grupları süz                          -> HAVING
   ------------------------------------------------------------ */
SELECT p.customer_id,
       c.first_name,
       c.last_name,
       count(*) AS alisveris_sayisi
FROM payment AS p
JOIN customer AS c ON c.customer_id = p.customer_id
GROUP BY p.customer_id, c.first_name, c.last_name
HAVING count(*) = (SELECT max(adet)
                   FROM (SELECT count(*) AS adet
                         FROM payment
                         GROUP BY customer_id) AS t)
ORDER BY p.customer_id;
-- 1 satır: customer_id 148, Eleanor Hunt, 45 alışveriş

-- ORDER BY ... LIMIT 1 ile daha kısa ama eksik bir alternatif:
-- (beraberlik olsaydı yalnızca birini döndürürdü)
SELECT p.customer_id,
       c.first_name,
       c.last_name,
       count(*) AS alisveris_sayisi
FROM payment AS p
JOIN customer AS c ON c.customer_id = p.customer_id
GROUP BY p.customer_id, c.first_name, c.last_name
ORDER BY alisveris_sayisi DESC
LIMIT 1;
