# Ödev 10 — `LEFT` / `RIGHT` / `FULL JOIN`

**Veritabanı:** `dvdrental` (PostgreSQL 16)
**Çözüm:** [`cozum.sql`](cozum.sql) · **Soru metni:** [`soru.md`](soru.md)

## OUTER JOIN türleri

| Tür | Hangi satırlar korunur? | Eşleşmeyen taraf |
|---|---|---|
| `INNER JOIN` | Yalnızca her iki tarafta eşleşenler | — |
| `LEFT JOIN` | **Sol** tablonun tümü | Sağ sütunlar `NULL` |
| `RIGHT JOIN` | **Sağ** tablonun tümü | Sol sütunlar `NULL` |
| `FULL JOIN` | **Her iki** tablonun tümü | Eşleşmeyen taraf `NULL` |

`OUTER` kelimesi opsiyoneldir: `LEFT JOIN` ≡ `LEFT OUTER JOIN`.

---

## Soru 1 — `city` ⟕ `country` (`LEFT JOIN`)

```sql
SELECT ci.city,
       co.country
FROM city AS ci
LEFT JOIN country AS co
       ON ci.country_id = co.country_id;
```

Sol tablo `city` olduğundan, `country` tablosunda karşılığı bulunmayan şehirler de
sonuca dahil olur ve `country` sütunu `NULL` gelir.

**Sonuç:** 600 satır — `city` tablosunun tamamı.

Eşleşmeyen satır kontrolü **0 satır** döndürüyor, yani ülkesi tanımsız hiçbir
şehir yok:

```sql
SELECT ci.city, ci.country_id
FROM city AS ci
LEFT JOIN country AS co ON ci.country_id = co.country_id
WHERE co.country_id IS NULL;   -- 0 satır
```

---

## Soru 2 — `customer` ⟖ `payment` (`RIGHT JOIN`)

```sql
SELECT p.payment_id,
       c.first_name,
       c.last_name
FROM customer AS c
RIGHT JOIN payment AS p
        ON c.customer_id = p.customer_id;
```

Sağ tablo `payment` olduğundan, müşterisi bulunmayan ödemeler de sonuca dahil
olur ve isim sütunları `NULL` gelir.

**Sonuç:** 14.596 satır — `payment` tablosunun tamamı.

### `RIGHT JOIN` yerine `LEFT JOIN`

Her `RIGHT JOIN`, tabloların yeri değiştirilerek `LEFT JOIN` olarak yazılabilir —
aşağıdaki iki sorgu birebir aynı sonucu verir:

```sql
FROM customer c RIGHT JOIN payment  p ON c.customer_id = p.customer_id
FROM payment   p LEFT  JOIN customer c ON c.customer_id = p.customer_id
```

Pratikte `LEFT JOIN` tercih edilir: "ana tablo soldadır, ek bilgi sağdan gelir"
mantığı zincirleme JOIN'lerde okumayı kolaylaştırır. `RIGHT JOIN` nadiren
kullanılır, bu yüzden ödevde ayrıca sorulmuştur.

---

## Soru 3 — `customer` ⟗ `rental` (`FULL JOIN`)

```sql
SELECT r.rental_id,
       c.first_name,
       c.last_name
FROM customer AS c
FULL JOIN rental AS r
       ON c.customer_id = r.customer_id;
```

**Sonuç:** 16.044 satır — `rental` tablosunun tamamı.

Eşleşmeyen satır kontrolü yine **0** döndürüyor: ne müşterisi olmayan bir
kiralama, ne de hiç kiralama yapmamış bir müşteri var.

```sql
SELECT count(*)
FROM customer c
FULL JOIN rental r ON c.customer_id = r.customer_id
WHERE c.customer_id IS NULL OR r.rental_id IS NULL;   -- 0
```

---

## Önemli gözlem: bu veritabanında dört JOIN türü de aynı sonucu veriyor

`city` / `country` için satır sayıları:

| JOIN türü | Dönen satır |
|---|---|
| `INNER JOIN` | 600 |
| `LEFT JOIN` | 600 |
| `RIGHT JOIN` | 600 |
| `FULL JOIN` | 600 |

Sebebi: `dvdrental` veritabanında **yabancı anahtar kısıtları eksiksizdir**. Her
şehrin geçerli bir ülkesi, her ödemenin ve kiralamanın geçerli bir müşterisi var
— yani **hiç yetim (orphan) satır yok**. Eşleşmeyen satır olmadığında
`OUTER JOIN`'lerin `NULL` ile dolduracağı hiçbir satır kalmaz ve hepsi
`INNER JOIN` ile aynı sonucu üretir.

Doğrulama:

| Kontrol | Sonuç |
|---|---|
| Ülkesi olmayan şehir | 0 |
| Şehri olmayan ülke | 0 |
| Ödemesi olmayan müşteri | 0 |
| Kiralaması olmayan müşteri | 0 |

### Farkı görmek için küçük bir örnek

Farkın gerçekten ne olduğunu göstermek için kasıtlı olarak eşleşmeyen satırlar
içeren iki küçük tablo kuralım (`sol` tablosunda `id = 1` fazla, `sag`
tablosunda `id = 4` fazla):

```sql
WITH sol(id, ad)    AS (VALUES (1,'A'), (2,'B'), (3,'C')),
     sag(id, deger) AS (VALUES (2,'X'), (3,'Y'), (4,'Z'))
SELECT * FROM sol LEFT JOIN sag ON sol.id = sag.id;
```

| JOIN türü | sol_id | ad | sag_id | deger | Satır |
|---|---|---|---|---|---|
| **INNER** | 2 | B | 2 | X | 2 satır |
| | 3 | C | 3 | Y | |
| **LEFT** | 1 | A | `NULL` | `NULL` | 3 satır |
| | 2 | B | 2 | X | |
| | 3 | C | 3 | Y | |
| **RIGHT** | 2 | B | 2 | X | 3 satır |
| | 3 | C | 3 | Y | |
| | `NULL` | `NULL` | 4 | Z | |
| **FULL** | 1 | A | `NULL` | `NULL` | 4 satır |
| | 2 | B | 2 | X | |
| | 3 | C | 3 | Y | |
| | `NULL` | `NULL` | 4 | Z | |

- `LEFT JOIN` soldaki fazlalık `A`'yı korudu.
- `RIGHT JOIN` sağdaki fazlalık `Z`'yi korudu.
- `FULL JOIN` ikisini de korudu.
- `INNER JOIN` ikisini de attı.

Bu sorgu `cozum.sql` dosyasının sonunda çalıştırılabilir hâlde bulunuyor.

---

## Özet

| Soru | JOIN | Dönen satır | Not |
|---|---|---|---|
| 1 | `city LEFT JOIN country` | 600 | Eşleşmeyen şehir yok |
| 2 | `customer RIGHT JOIN payment` | 14.596 | Müşterisiz ödeme yok |
| 3 | `customer FULL JOIN rental` | 16.044 | Her iki yönde eşleşmeyen yok |
