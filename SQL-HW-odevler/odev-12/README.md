# Ödev 12 — Alt Sorgular (Subquery)

**Veritabanı:** `dvdrental` (PostgreSQL 16)
**Çözüm:** [`cozum.sql`](cozum.sql) · **Soru metni:** [`soru.md`](soru.md)

## Alt sorgu neden gerekli?

Şu sorguyu yazmak istiyoruz: "ortalamadan uzun filmler". Doğal olan yazım hata verir:

```sql
SELECT count(*) FROM film WHERE length > avg(length);
-- ERROR: aggregate functions are not allowed in WHERE
```

Sebebi çalışma sırası: `WHERE` satırları **tek tek** değerlendirir, ama `avg()`
tüm satırların görülmesini gerektirir. `WHERE` çalışırken ortalama henüz
hesaplanmamıştır.

Çözüm, ortalamayı **önce** ayrı bir sorguda hesaplamaktır:

```sql
WHERE length > (SELECT avg(length) FROM film)
```

Parantez içindeki `SELECT` tek satır–tek sütun döndürdüğü için **skaler alt
sorgu** adını alır ve normal bir değer gibi kullanılabilir.

---

## Soru 1 — Ortalamadan uzun filmler

```sql
SELECT count(*) AS film_sayisi
FROM film
WHERE length > (SELECT avg(length) FROM film);
```

**Cevap: 489 film**

| Değer | |
|---|---|
| Ortalama film uzunluğu | 115.27 dakika |
| Ortalamadan uzun film sayısı | **489** |
| Toplam film sayısı | 1000 |

489 sayısı 500'e yakın ama tam yarısı değil — uzunluk dağılımı tam simetrik
olmadığı için ortalamanın altında kalan film sayısı biraz daha fazla (511).

---

## Soru 2 — En yüksek `rental_rate`'e sahip film sayısı

```sql
SELECT count(*) AS film_sayisi
FROM film
WHERE rental_rate = (SELECT max(rental_rate) FROM film);
```

**Cevap: 336 film** (en yüksek `rental_rate` = 4.99)

`rental_rate` sütunu yalnızca üç değer alıyor (0.99 / 2.99 / 4.99) ve 1000 film
bunlara kabaca eşit dağılmış — bu yüzden "en yüksek değere sahip film sayısı"
üçte bire yakın çıkıyor.

> Burada alt sorgu kullanmak zorunlu: `WHERE rental_rate = max(rental_rate)`
> yazmak 1. soruda olduğu gibi hata verir. Alternatif olarak değeri elle
> (`WHERE rental_rate = 4.99`) yazabilirdik, ama o zaman sorgu veriye bağımlı
> hâle gelirdi — yeni bir fiyat eklendiğinde yanlış sonuç verirdi. Alt sorgu
> maksimumu her çalıştırmada yeniden hesaplar.

---

## Soru 3 — En düşük `rental_rate` **ve** en düşük `replacement_cost`

```sql
SELECT *
FROM film
WHERE rental_rate      = (SELECT min(rental_rate)      FROM film)
  AND replacement_cost = (SELECT min(replacement_cost) FROM film);
```

İki ayrı skaler alt sorgu `AND` ile birleştirildi: `rental_rate = 0.99` **ve**
`replacement_cost = 9.99`.

**Sonuç:** 15 satır.

| film_id | title | rental_rate | replacement_cost |
|---|---|---|---|
| 23 | Anaconda Confessions | 0.99 | 9.99 |
| 221 | Deliverance Mulholland | 0.99 | 9.99 |
| 281 | Encino Elf | 0.99 | 9.99 |
| 299 | Factory Dragon | 0.99 | 9.99 |
| 348 | Gandhi Kwai | 0.99 | 9.99 |
| 623 | Newton Labyrinth | 0.99 | 9.99 |
| 629 | Notorious Reunion | 0.99 | 9.99 |
| 656 | Papi Necklace | 0.99 | 9.99 |
| 747 | Roxanne Rebel | 0.99 | 9.99 |
| 863 | Sun Confessions | 0.99 | 9.99 |
| 875 | Talented Homicide | 0.99 | 9.99 |
| 886 | Theory Mermaid | 0.99 | 9.99 |
| 931 | Valentine Vanishing | 0.99 | 9.99 |
| 953 | Wait Cider | 0.99 | 9.99 |
| 996 | Young Language | 0.99 | 9.99 |

> Dikkat: bu sorgu "her iki sütunda da minimum olan" filmleri getirir, "en ucuz
> filmi" değil. İki koşul bağımsız olarak uygulanıyor — `AND` yerine `OR`
> yazılsaydı, yalnızca bir koşulu sağlayan filmler de listeye girerdi.

---

## Soru 4 — En fazla alışveriş yapan müşteriler

```sql
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
```

**Cevap:**

| customer_id | first_name | last_name | alışveriş sayısı |
|---|---|---|---|
| 148 | Eleanor | Hunt | **45** |

### Sorgunun kurgusu

Bu soru, önceki ödevlerdeki üç yapıyı birleştiriyor:

1. **`GROUP BY`** (Ödev 7) — her müşterinin ödeme sayısını bul.
2. **İç içe alt sorgu** — bu sayıların en büyüğünü bul:

   ```sql
   SELECT max(adet)
   FROM (SELECT count(*) AS adet FROM payment GROUP BY customer_id) AS t
   ```

   İçteki sorgu müşteri başına ödeme sayılarını üretir, dıştaki `max()` bunların
   en büyüğünü alır. `max(count(*))` şeklinde iç içe toplama fonksiyonu yazmak
   SQL'de geçersizdir; bu yüzden ara sonucu bir alt sorguya almak gerekir.
   `FROM` içindeki alt sorguya PostgreSQL'de **takma ad vermek zorunludur**
   (`AS t`) — verilmezse sözdizimi hatası alınır.

3. **`HAVING`** (Ödev 7) — ödeme sayısı bu maksimuma eşit olan grupları süz.
4. **`JOIN`** (Ödev 9) — müşterinin adını `customer` tablosundan getir.

### Neden `ORDER BY … LIMIT 1` değil?

Daha kısa bir alternatif şudur:

```sql
... GROUP BY ... ORDER BY alisveris_sayisi DESC LIMIT 1
```

Bu sorgu da 148 numaralı müşteriyi döndürür, ancak soru **"müşterileri"** diye
çoğul soruyor. Birden fazla müşteri aynı en yüksek sayıya sahip olsaydı
`LIMIT 1` bunlardan yalnızca birini gösterir, diğerlerini **sessizce gizlerdi**.
`HAVING count(*) = (SELECT max(...))` yapısı ise zirvedeki **tüm** müşterileri
garanti eder.

Bu veri setinde beraberlik yok — ilk beş müşteri:

| customer_id | alışveriş sayısı |
|---|---|
| **148** | **45** ← tek zirve |
| 526 | 42 |
| 144 | 40 |
| 75 | 39 |
| 236 | 39 |

(4. ve 5. sıradaki beraberlik, `LIMIT` yaklaşımının neden riskli olduğunu
gösteriyor: soru "en fazla ikinci" olsaydı `LIMIT` ile iki müşteriden biri
kaybolurdu.)

---

## Özet

| Soru | Alt sorgu türü | Cevap |
|---|---|---|
| 1 | `WHERE … > (SELECT avg(…))` | 489 film (ortalama 115.27 dk) |
| 2 | `WHERE … = (SELECT max(…))` | 336 film (rental_rate 4.99) |
| 3 | İki skaler alt sorgu + `AND` | 15 film (0.99 / 9.99) |
| 4 | `HAVING … = (SELECT max(...))` + iç içe alt sorgu | Eleanor Hunt (148), 45 alışveriş |
