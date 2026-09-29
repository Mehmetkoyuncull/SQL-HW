# Ödev 7 — `GROUP BY` ve `HAVING`

**Veritabanı:** `dvdrental` (PostgreSQL 16)
**Çözüm:** [`cozum.sql`](cozum.sql) · **Soru metni:** [`soru.md`](soru.md)

## Sorgu çalışma sırası

```
FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT
```

Bu sıra, `WHERE` ile `HAVING` arasındaki farkın kaynağıdır:

| | Ne zaman çalışır? | Neyi filtreler? | Toplama fonksiyonu kullanılabilir mi? |
|---|---|---|---|
| `WHERE` | Gruplama **öncesi** | Tek tek satırları | ❌ Hayır |
| `HAVING` | Gruplama **sonrası** | Grupları | ✅ Evet |

---

## Soru 1 — Filmleri `rating` değerine göre gruplama

```sql
SELECT rating,
       count(*) AS film_sayisi
FROM film
GROUP BY rating
ORDER BY film_sayisi DESC;
```

**Sonuç:** 5 grup, toplam 1000 film.

| rating | film sayısı |
|---|---|
| PG-13 | 223 |
| NC-17 | 210 |
| R | 195 |
| PG | 194 |
| G | 178 |
| **Toplam** | **1000** |

> `GROUP BY` ile birlikte `SELECT` listesinde yalnızca **gruplama sütunları** ve
> **toplama fonksiyonları** yer alabilir. Örneğin `SELECT rating, title … GROUP BY rating`
> yazmak hata verir, çünkü bir `rating` grubunda yüzlerce farklı `title` vardır ve
> PostgreSQL hangisini göstereceğini bilemez.

---

## Soru 2 — `HAVING` ile grup filtresi

```sql
SELECT replacement_cost,
       count(*) AS film_sayisi
FROM film
GROUP BY replacement_cost
HAVING count(*) > 50
ORDER BY film_sayisi DESC;
```

Koşul tek tek satırlara değil, **grubun büyüklüğüne** uygulandığı için `WHERE`
değil `HAVING` kullanılır. `WHERE count(*) > 50` yazmak şu hatayı verir:

```
ERROR: aggregate functions are not allowed in WHERE
```

**Sonuç:** 21 gruptan 8'i koşulu sağlıyor.

| replacement_cost | film sayısı |
|---|---|
| 20.99 | 57 |
| 21.99 | 55 |
| 12.99 | 55 |
| 22.99 | 55 |
| 13.99 | 55 |
| 27.99 | 53 |
| 29.99 | 53 |
| 14.99 | 51 |

Soru "50'den **fazla**" dediği için `> 50` yazıldı; `>= 50` yazılsaydı tam 50
filmli gruplar da listeye eklenirdi.

---

## Soru 3 — Mağaza başına müşteri sayısı

```sql
SELECT store_id,
       count(*) AS musteri_sayisi
FROM customer
GROUP BY store_id
ORDER BY store_id;
```

**Sonuç:**

| store_id | müşteri sayısı |
|---|---|
| 1 | 326 |
| 2 | 273 |
| **Toplam** | **599** |

---

## Soru 4 — En fazla şehir barındıran ülke

```sql
SELECT country_id,
       count(*) AS sehir_sayisi
FROM city
GROUP BY country_id
ORDER BY sehir_sayisi DESC
LIMIT 1;
```

**Cevap: `country_id = 44`, 60 şehir**

`country_id` tek başına pek anlam taşımadığı için `country` tablosuyla
birleştirip ülke adını da getirebiliriz:

```sql
SELECT ci.country_id,
       co.country,
       count(*) AS sehir_sayisi
FROM city ci
JOIN country co ON co.country_id = ci.country_id
GROUP BY ci.country_id, co.country
ORDER BY sehir_sayisi DESC
LIMIT 1;
```

İlk beş ülke:

| country_id | ülke | şehir sayısı |
|---|---|---|
| **44** | **India** | **60** |
| 23 | China | 53 |
| 103 | United States | 35 |
| 50 | Japan | 31 |
| 60 | Mexico | 30 |

> `LIMIT 1` kullanırken dikkat: birden fazla ülke aynı en yüksek şehir sayısına
> sahip olsaydı bunlardan yalnızca biri dönerdi. Burada India (60) ile ikinci
> sıradaki China (53) arasında fark olduğu için sorun yok. Tüm zirveyi
> garantilemek için `HAVING count(*) = (SELECT max(...) ...)` yapısı kullanılır
> — bu yapının bir örneği Ödev 12'nin 4. sorusunda var.

---

## Özet

| Soru | Yapı | Sonuç |
|---|---|---|
| 1 | `GROUP BY rating` | 5 grup (PG-13 en kalabalık: 223) |
| 2 | `GROUP BY … HAVING count(*) > 50` | 8 grup |
| 3 | `GROUP BY store_id` | 326 / 273 |
| 4 | `GROUP BY … ORDER BY … LIMIT 1` | country_id 44 (India), 60 şehir |
