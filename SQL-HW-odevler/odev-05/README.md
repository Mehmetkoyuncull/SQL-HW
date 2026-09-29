# Ödev 5 — `ORDER BY`, `LIMIT` ve `OFFSET`

**Veritabanı:** `dvdrental` (PostgreSQL 16)
**Çözüm:** [`cozum.sql`](cozum.sql) · **Soru metni:** [`soru.md`](soru.md)

`title LIKE '%n'` koşulunu sağlayan toplam **112 film** var; 1. ve 2. sorular bu
112 kayıt üzerinden sıralanıyor.

---

## Soru 1 — 'n' ile biten en uzun 5 film

```sql
SELECT *
FROM film
WHERE title LIKE '%n'
ORDER BY length DESC
LIMIT 5;
```

"En uzun" istendiği için `length` sütununa göre **azalan** (`DESC`) sıralama
yapılır, ardından `LIMIT 5` ile ilk 5 satır alınır.

**Sonuç:**

| # | film_id | title | length |
|---|---|---|---|
| 1 | 817 | Soldiers Evolution | 185 |
| 2 | 821 | Sorority Queen | 184 |
| 3 | 499 | King Evolution | 184 |
| 4 | 340 | Frontier Cabin | 183 |
| 5 | 973 | Wife Turn | 183 |

---

## Soru 2 — 'n' ile biten en kısa **ikinci** 5 film (6–10. sıra)

```sql
SELECT *
FROM film
WHERE title LIKE '%n'
ORDER BY length ASC
LIMIT 5 OFFSET 5;
```

`OFFSET 5` ilk 5 satırı **atlar**, `LIMIT 5` ondan sonraki 5 satırı alır — yani
6, 7, 8, 9 ve 10. sıradakiler. `OFFSET`, sayfalama (pagination) mantığının
temelidir: *n*. sayfayı almak için `LIMIT sayfa_boyutu OFFSET (n-1) * sayfa_boyutu`.

**Sonuç:**

| sıra | film_id | title | length |
|---|---|---|---|
| 6 | 481 | Jekyll Frogmen | 58 |
| 7 | 214 | Daughter Madigan | 59 |
| 8 | 743 | Room Roman | 60 |
| 9 | 114 | Camelot Vacation | 61 |
| 10 | 77 | Birds Perdition | 61 |

Atlanan ilk 5 satır (doğrulama için):

| sıra | title | length |
|---|---|---|
| 1 | Iron Moon | 46 |
| 2 | Shanghai Tycoon | 47 |
| 3 | Heavenly Gun | 49 |
| 4 | Matrix Snowman | 56 |
| 5 | Mosquito Armageddon | 57 |

### Dikkat edilmesi gereken nokta — beraberlik (tie) problemi

9. ve 10. sıradaki filmlerin ikisi de **61 dakika**. Aynı `length` değerine sahip
birden fazla film olduğunda, `ORDER BY length` bu satırlar arasında bir sıra
garanti **etmez** — PostgreSQL bunları her çalıştırmada farklı sırada
döndürebilir. Nitekim `length = 61` olan 4 film var (`Camelot Vacation`,
`Birds Perdition`, `Polish Brooklyn`, `Reservoir Adaptation`), yani 9–10. sıraya
hangisinin geleceği belirsiz.

Her çalıştırmada aynı sonucu almak için **ikincil sıralama sütunu** eklenmelidir:

```sql
ORDER BY length ASC, film_id ASC
```

---

## Soru 3 — `store_id = 1`, `last_name` azalan, ilk 4 kayıt

```sql
SELECT *
FROM customer
WHERE store_id = 1
ORDER BY last_name DESC
LIMIT 4;
```

Çalışma sırası önemlidir: önce `WHERE` ile satırlar filtrelenir, **sonra**
`ORDER BY` ile sıralanır, en son `LIMIT` uygulanır. Yani "önce sırala, sonra
filtrele" gibi bir sonuç çıkmaz — `store_id = 1` olan 326 müşteri içinde
soyadı alfabetik olarak en sonda gelen 4 kişi döner.

**Sonuç:**

| customer_id | first_name | last_name | store_id |
|---|---|---|---|
| 28 | Cynthia | Young | 1 |
| 402 | Luis | Yanez | 1 |
| 318 | Brian | Wyman | 1 |
| 107 | Florence | Woods | 1 |

---

## Özet

| Soru | Yapı | Sonuç |
|---|---|---|
| 1 | `ORDER BY length DESC LIMIT 5` | 5 satır (185 … 183 dk) |
| 2 | `ORDER BY length ASC LIMIT 5 OFFSET 5` | 5 satır (58 … 61 dk) |
| 3 | `WHERE` + `ORDER BY … DESC LIMIT 4` | 4 satır (Young … Woods) |
