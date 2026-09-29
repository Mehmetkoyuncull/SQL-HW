# Ödev 1 — Temel `SELECT` ve `WHERE` Sorguları

**Veritabanı:** `dvdrental` (PostgreSQL)
**Çözüm dosyası:** [`cozum.sql`](cozum.sql) · **Soru metni:** [`soru.md`](soru.md)

Tüm sorgular gerçek `dvdrental` veritabanı üzerinde çalıştırılarak doğrulanmıştır.
(PostgreSQL 16, `film` tablosu 1000 satır)

---

## Soru 1 — `title` ve `description` sütunlarını listele

```sql
SELECT title,
       description
FROM film;
```

`SELECT`'ten sonra istenen sütun adları virgülle ayrılarak yazılır.
`*` yerine sütun adı vermek, tablodan yalnızca ihtiyaç duyulan veriyi çeker.

**Sonuç:** 1000 satır.

| title | description |
|---|---|
| Chamber Italian | A Fateful Reflection of a Moose And a Husband... |
| Grosse Wonderful | A Epic Drama of a Cat And a Explorer who must... |
| Airport Pollock | A Epic Tale of a Moose And a Girl who must Co... |
| … | … |

> Alfabetik sıralı istenirse sona `ORDER BY title;` eklenir.

---

## Soru 2 — `length` 60'tan büyük VE 75'ten küçük

```sql
SELECT *
FROM film
WHERE length > 60
  AND length < 75;
```

İki koşulun **aynı anda** sağlanması istendiği için `AND` kullanılır.
Sınır değerler (`60` ve `75`) "büyük/küçük" dendiği için dahil **değildir** —
yani aralık `61 … 74`.

**Sonuç:** 104 satır.

> `BETWEEN` sınırları dahil ettiğinden (`BETWEEN 60 AND 75` → `60 <= length <= 75`)
> bu soruda doğrudan kullanılamaz; kullanılacaksa `BETWEEN 61 AND 74` yazılmalıdır.

---

## Soru 3 — `rental_rate` 0.99 VE `replacement_cost` 12.99 veya 28.99

```sql
SELECT *
FROM film
WHERE rental_rate = 0.99
  AND (replacement_cost = 12.99 OR replacement_cost = 28.99);
```

**Buradaki kritik nokta parantez.** SQL'de operatör önceliği gereği `AND`,
`OR`'dan önce çalışır. Parantez yazılmazsa sorgu şu şekilde yorumlanır:

```sql
-- YANLIŞ: parantezsiz hâli
(rental_rate = 0.99 AND replacement_cost = 12.99) OR (replacement_cost = 28.99)
```

Bu hâliyle `rental_rate` değeri 0.99 olmayan ama `replacement_cost` değeri 28.99
olan filmler de sonuca dahil olur.

| Sorgu | Dönen satır |
|---|---|
| Parantezli (**doğru**) | **37** |
| Parantezsiz (yanlış) | 63 |

Aynı sorgu `IN` ile daha kısa yazılabilir (sonuç yine 37 satır):

```sql
SELECT *
FROM film
WHERE rental_rate = 0.99
  AND replacement_cost IN (12.99, 28.99);
```

Sonuçtan bir kesit:

| film_id | title | rental_rate | replacement_cost |
|---|---|---|---|
| 27 | Anonymous Human | 0.99 | 12.99 |
| 36 | Argonauts Town | 0.99 | 12.99 |
| 245 | Double Wrath | 0.99 | 28.99 |
| 306 | Feathers Metal | 0.99 | 12.99 |
| 344 | Fury Murder | 0.99 | 28.99 |
| … | … | … | … |

---

## Soru 4 — `first_name` = 'Mary' olan müşterinin soyadı

```sql
SELECT last_name
FROM customer
WHERE first_name = 'Mary';
```

**Cevap: `Smith`**

| customer_id | first_name | last_name |
|---|---|---|
| 1 | Mary | Smith |

Metinsel değerler PostgreSQL'de **tek tırnak** (`'Mary'`) ile yazılır; çift tırnak
sütun/tablo adı belirtmek için kullanılır. Karşılaştırma büyük-küçük harf duyarlıdır,
`'mary'` yazılsaydı hiçbir satır dönmezdi.

---

## Soru 5 — `length` > 50 OLMAYAN ve `rental_rate` 2.99/4.99 OLMAYAN

Soru "**olmayıp**" ve "**olmayan**" dediği için koşullar `NOT` ile yazıldı:

```sql
SELECT *
FROM film
WHERE NOT (length > 50)
  AND NOT (rental_rate = 2.99 OR rental_rate = 4.99);
```

Mantıksal olarak sadeleştirilmiş, okunması daha kolay hâli (aynı 13 satırı döner):

```sql
SELECT *
FROM film
WHERE length <= 50
  AND rental_rate NOT IN (2.99, 4.99);
```

- `NOT (length > 50)` → `length <= 50`
- `NOT (a OR b)` → `NOT a AND NOT b` (De Morgan kuralı) → `rental_rate NOT IN (2.99, 4.99)`

`dvdrental` veritabanında `rental_rate` yalnızca `0.99`, `2.99` ve `4.99` değerlerini
aldığından, ikinci koşul pratikte `rental_rate = 0.99` anlamına gelir.

**Sonuç:** 13 satır.

| film_id | title | length | rental_rate |
|---|---|---|---|
| 247 | Downhill Enough | 47 | 0.99 |
| 407 | Hawk Chill | 47 | 0.99 |
| 430 | Hook Chariots | 49 | 0.99 |
| 504 | Kwai Homeward | 46 | 0.99 |
| 524 | Lion Uncut | 50 | 0.99 |
| 617 | Natural Stock | 50 | 0.99 |
| 630 | Notting Speakeasy | 48 | 0.99 |
| 634 | Odds Boogie | 48 | 0.99 |
| … | … | … | … |

---

## Özet

| Soru | Konu | Dönen satır |
|---|---|---|
| 1 | Sütun seçimi | 1000 |
| 2 | `AND` ile aralık | 104 |
| 3 | `AND` + `OR` önceliği, parantez | 37 |
| 4 | Metin karşılaştırma | 1 (`Smith`) |
| 5 | `NOT` / `NOT IN` | 13 |
