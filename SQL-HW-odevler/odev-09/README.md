# Ödev 9 — `INNER JOIN`

**Veritabanı:** `dvdrental` (PostgreSQL 16)
**Çözüm:** [`cozum.sql`](cozum.sql) · **Soru metni:** [`soru.md`](soru.md)

`INNER JOIN`, iki tabloda **karşılıklı eşleşen** satırları birleştirir.
Eşleşmeyen satırlar sonuca **girmez**. `JOIN` yazmak `INNER JOIN` ile aynıdır
(`INNER` kelimesi opsiyoneldir).

```sql
FROM sol_tablo
INNER JOIN sag_tablo ON sol_tablo.ortak_sutun = sag_tablo.ortak_sutun
```

---

## Soru 1 — `city` ⋈ `country`

```sql
SELECT ci.city,
       co.country
FROM city AS ci
INNER JOIN country AS co
        ON ci.country_id = co.country_id;
```

**Bağlantı (join) sütunu:** `city.country_id` → `country.country_id`
(`city` tablosundaki yabancı anahtar, `country` tablosunun birincil anahtarına bakar.)

**Sonuç:** 600 satır.

| city | country |
|---|---|
| Kabul | Afghanistan |
| Batna | Algeria |
| Bchar | Algeria |
| Skikda | Algeria |
| Tafuna | American Samoa |
| Benguela | Angola |
| … | … |

### Takma ad (alias) kullanımı

`city AS ci` yazmak sorguyu kısaltır. Bu sorguda alias özellikle işe yarar, çünkü
`city` hem tablo hem de sütun adıdır — alias olmadan `city.city` yazmak gerekir.
Sütun adları iki tabloda da aynı olduğu için `USING` kısayolu da kullanılabilir:

```sql
SELECT city, country
FROM city
INNER JOIN country USING (country_id);
```

---

## Soru 2 — `customer` ⋈ `payment`

```sql
SELECT p.payment_id,
       c.first_name,
       c.last_name
FROM customer AS c
INNER JOIN payment AS p
        ON c.customer_id = p.customer_id;
```

**Sonuç:** 14.596 satır.

| payment_id | first_name | last_name |
|---|---|---|
| 17503 | Peter | Menard |
| 17504 | Peter | Menard |
| 17505 | Peter | Menard |
| 17506 | Peter | Menard |
| … | … | … |

### Neden aynı isim tekrar ediyor?

İlişki **bire-çok**: bir müşterinin birden fazla ödemesi olabilir. `customer`
tablosunda 599 satır varken sonuç 14.596 satır — çünkü her ödeme kaydı için
müşterinin adı yeniden yazılır. Ortalama olarak müşteri başına ~24 ödeme düşüyor.

---

## Soru 3 — `customer` ⋈ `rental`

```sql
SELECT r.rental_id,
       c.first_name,
       c.last_name
FROM customer AS c
INNER JOIN rental AS r
        ON c.customer_id = r.customer_id;
```

**Sonuç:** 16.044 satır.

| rental_id | first_name | last_name |
|---|---|---|
| 1 | Charlotte | Hunter |
| 2 | Tommy | Collazo |
| 3 | Manuel | Murrell |
| 4 | Andrew | Purdy |
| 5 | Delores | Hansen |
| 6 | Nelson | Christenson |
| … | … | … |

---

## Satır sayıları karşılaştırması

| Tablo | Satır sayısı |
|---|---|
| `city` | 600 |
| `country` | 109 |
| `customer` | 599 |
| `payment` | 14.596 |
| `rental` | 16.044 |

| Sorgu | Dönen satır | Yorum |
|---|---|---|
| `city ⋈ country` | 600 | `city` ile aynı — her şehrin tam bir ülkesi var |
| `customer ⋈ payment` | 14.596 | `payment` ile aynı — her ödemenin bir müşterisi var |
| `customer ⋈ rental` | 16.044 | `rental` ile aynı — her kiralamanın bir müşterisi var |

Üç sorguda da sonuç, **"çok" tarafındaki** tablonun satır sayısına eşit. Bu,
veritabanında **yabancı anahtar kısıtlarının eksiksiz** olduğunu gösterir: hiçbir
şehir ülkesiz, hiçbir ödeme/kiralama müşterisiz değil. Eğer örneğin ülkesi
tanımsız bir şehir olsaydı, `INNER JOIN` o satırı **sessizce düşürür** ve sonuç
600'den az olurdu.

> Bu durum Ödev 10'daki `LEFT` / `RIGHT` / `FULL JOIN` sonuçlarının neden
> `INNER JOIN` ile birebir aynı çıktığını da açıklıyor.

### Kiralama sayısı (16.044) ile ödeme sayısı (14.596) neden farklı?

Aradaki 1.448 satırlık fark iki etkinin toplamıdır:

- `rental` tablosundaki **1.452** kiralama kaydının `payment` tablosunda hiç
  karşılığı yok (ödemesi kaydedilmemiş kiralamalar).
- Buna karşılık **4** kiralama için ikişer ödeme satırı var
  (14.596 ödeme satırı, yalnızca 14.592 farklı `rental_id`'ye dağılıyor).

1.452 − 4 = 1.448. Bu, veri setinin doğal bir özelliğidir ve iki `INNER JOIN`
sorgusunun farklı satır sayısı döndürmesinin sebebidir.

---

## Özet

| Soru | Birleşim | Bağlantı sütunu | Dönen satır |
|---|---|---|---|
| 1 | `city` ⋈ `country` | `country_id` | 600 |
| 2 | `customer` ⋈ `payment` | `customer_id` | 14.596 |
| 3 | `customer` ⋈ `rental` | `customer_id` | 16.044 |
