# Ödev 6 — Toplama (Aggregate) Fonksiyonları

**Veritabanı:** `dvdrental` (PostgreSQL 16)
**Çözüm:** [`cozum.sql`](cozum.sql) · **Soru metni:** [`soru.md`](soru.md)

Toplama fonksiyonları, birçok satırı **tek bir değere** indirger:
`AVG()`, `COUNT()`, `MAX()`, `MIN()`, `SUM()`.

---

## Soru 1 — `rental_rate` ortalaması

```sql
SELECT avg(rental_rate) AS ortalama_rental_rate
FROM film;
```

**Cevap: 2.98**

Ham çıktı `2.9800000000000000` şeklinde gelir — çünkü `rental_rate` sütunu
`numeric(4,2)` tipinde olduğundan `avg()` sonucu yüksek hassasiyetli `numeric`
döner. Okunabilir çıktı için yuvarlanır:

```sql
SELECT round(avg(rental_rate), 2) AS ortalama_rental_rate
FROM film;   -- 2.98
```

> `rental_rate` yalnızca 0.99 / 2.99 / 4.99 değerlerini aldığı için ortalamanın
> tam ortadaki değere (2.99) çok yakın çıkması beklenir.

---

## Soru 2 — 'C' ile başlayan film sayısı

```sql
SELECT count(*) AS film_sayisi
FROM film
WHERE title LIKE 'C%';
```

**Cevap: 92**

`count(*)`, `WHERE` koşulundan geçen satırları sayar. Filtre `LIKE 'C%'` deseniyle
yalnızca baş harfe bakar; `LIKE` harf duyarlı olduğu için küçük `c` ile başlayan
bir başlık olsa sayıma girmezdi (bu veri setinde tüm başlıklar büyük harfle
başlıyor).

---

## Soru 3 — `rental_rate = 0.99` olan en uzun film

```sql
SELECT max(length) AS en_uzun_dakika
FROM film
WHERE rental_rate = 0.99;
```

**Cevap: 184 dakika**

Bu uzunluğa sahip **3 film** var:

| title | length |
|---|---|
| Smoochy Control | 184 |
| Sorority Queen | 184 |
| Theory Mermaid | 184 |

### `MAX()` ile `ORDER BY … LIMIT 1` farkı

Soru "kaç dakikadır" diye sorduğu için `max(length)` doğrudan cevabı verir.
Alternatif olarak `ORDER BY length DESC LIMIT 1` yazılabilir, ancak bu yalnızca
**bir** film döndürür ve yukarıdaki gibi beraberlik olduğunda diğer ikisini
gizler. Aynı uzunluktaki tüm filmleri görmek için alt sorgu gerekir:

```sql
WHERE rental_rate = 0.99
  AND length = (SELECT max(length) FROM film WHERE rental_rate = 0.99)
```

---

## Soru 4 — `length > 150` olan filmlerde farklı `replacement_cost` sayısı

```sql
SELECT count(DISTINCT replacement_cost) AS farkli_deger_sayisi
FROM film
WHERE length > 150;
```

**Cevap: 21**

`count()` ve `DISTINCT` birlikte kullanılıyor: önce `WHERE` ile 150 dakikadan uzun
filmler süzülür, sonra bu alt kümedeki `replacement_cost` değerlerinin **tekil**
olanları sayılır.

İlginç olan şu: `film` tablosunun tamamında da 21 farklı `replacement_cost` değeri
var (bkz. Ödev 4, Soru 2). Yani 150 dakikadan uzun filmler, mümkün olan **tüm**
fiyat aralığını kapsıyor — uzun filmlerin belirli bir fiyat bandında toplanması
gibi bir eğilim yok.

---

## Özet

| Soru | Fonksiyon | Cevap |
|---|---|---|
| 1 | `avg()` | 2.98 |
| 2 | `count(*)` | 92 |
| 3 | `max()` | 184 dakika (3 film) |
| 4 | `count(DISTINCT …)` | 21 |
