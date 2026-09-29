# Ödev 4 — `DISTINCT` ve `COUNT`

**Veritabanı:** `dvdrental` (PostgreSQL 16)
**Çözüm:** [`cozum.sql`](cozum.sql) · **Soru metni:** [`soru.md`](soru.md)

---

## Soru 1 — Farklı `replacement_cost` değerleri

```sql
SELECT DISTINCT replacement_cost
FROM film
ORDER BY replacement_cost;
```

`DISTINCT`, tekrarlayan satırları teke indirir. `film` tablosunda 1000 satır var
ama `replacement_cost` yalnızca **21 farklı** değer alıyor:

```
9.99  10.99  11.99  12.99  13.99  14.99  15.99  16.99  17.99  18.99  19.99
20.99  21.99  22.99  23.99  24.99  25.99  26.99  27.99  28.99  29.99
```

Değerler 9.99'dan 29.99'a kadar **birer birer** artıyor — yani aradaki her tam
sayı + 0.99 değeri veri setinde mevcut.

**Sonuç:** 21 satır.

---

## Soru 2 — Kaç farklı `replacement_cost` değeri var?

```sql
SELECT count(DISTINCT replacement_cost) AS farkli_deger_sayisi
FROM film;
```

**Cevap: 21**

### `COUNT` varyantlarının karşılaştırması

| Sorgu | Ne sayar? | Sonuç |
|---|---|---|
| `count(*)` | Tüm satırlar | 1000 |
| `count(replacement_cost)` | `NULL` **olmayan** değerler | 1000 |
| `count(DISTINCT replacement_cost)` | Birbirinden farklı değerler | **21** |

`count(sütun_adı)` `NULL` değerleri **saymaz**; `count(*)` sayar. Bu sütunda hiç
`NULL` olmadığı için ilk ikisi aynı çıktı, ancak `NULL` içeren bir sütunda
sonuçlar farklı olurdu.

---

## Soru 3 — 'T' ile başlayan ve `rating = 'G'` olan filmler

```sql
SELECT count(*) AS film_sayisi
FROM film
WHERE title LIKE 'T%'
  AND rating = 'G';
```

**Cevap: 9**

| title | rating |
|---|---|
| Teen Apollo | G |
| Timberland Sky | G |
| Torque Bound | G |
| Tracy Cider | G |
| Traffic Hobbit | G |
| Trap Guys | G |
| Truman Crazy | G |
| Turn Star | G |
| Tycoon Gathering | G |

> `rating` sütunu `dvdrental`'da `mpaa_rating` adlı bir **enum** tipindedir
> (`G`, `PG`, `PG-13`, `R`, `NC-17`). `rating = 'G'` karşılaştırması sorunsuz
> çalışır çünkü PostgreSQL metni otomatik olarak enum tipine dönüştürür.

---

## Soru 4 — Tam 5 karakterli ülke isimleri

```sql
SELECT count(*) AS ulke_sayisi
FROM country
WHERE country LIKE '_____';
```

`_____` deseni 5 adet alt çizgiden oluşur ve **tam olarak** 5 karakteri
karşılar — `%` kullanılmadığı için ne daha kısa ne daha uzun isim eşleşir.

**Cevap: 13**

| country |
|---|
| Chile, China, Egypt, India, Italy, Japan, Kenya, Nauru, Nepal, Spain, Sudan, Tonga, Yemen |

Eşdeğer yazım: `WHERE length(country) = 5`

---

## Soru 5 — 'R' veya 'r' ile biten şehir isimleri

```sql
SELECT count(*) AS sehir_sayisi
FROM city
WHERE city ILIKE '%r';
```

**Cevap: 33**

`ILIKE` büyük/küçük harf farkını yok saydığı için tek desen hem `R` hem `r` ile
bitenleri yakalar. `ILIKE` kullanılmasa iki koşulun `OR` ile bağlanması gerekirdi:

```sql
WHERE city LIKE '%R' OR city LIKE '%r'
```

Örnek kayıtlar: `Ahmadnagar`, `Ambattur`, `Balikesir`, `Bchar`, `Bhavnagar`,
`Bijapur`, `Chandrapur`, `Cianjur`, …

---

## Özet

| Soru | Konu | Cevap |
|---|---|---|
| 1 | `DISTINCT` | 21 farklı değer |
| 2 | `count(DISTINCT …)` | 21 |
| 3 | `count(*)` + `LIKE` + enum karşılaştırma | 9 |
| 4 | `LIKE '_____'` (tam 5 karakter) | 13 |
| 5 | `count(*)` + `ILIKE '%r'` | 33 |
