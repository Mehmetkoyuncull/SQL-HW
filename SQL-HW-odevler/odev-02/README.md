# Ödev 2 — `BETWEEN` ve `IN` Operatörleri

**Veritabanı:** `dvdrental` (PostgreSQL 16)
**Çözüm:** [`cozum.sql`](cozum.sql) · **Soru metni:** [`soru.md`](soru.md)

Tüm sorgular gerçek veritabanında çalıştırılarak doğrulanmıştır.

---

## Soru 1 — `replacement_cost` için `BETWEEN … AND`

```sql
SELECT *
FROM film
WHERE replacement_cost BETWEEN 12.99 AND 16.99;
```

**Sonuç:** 236 satır.

### Dikkat edilmesi gereken nokta

`BETWEEN` **her iki sınırı da dahil eder**:

```sql
x BETWEEN a AND b   ⟺   x >= a AND x <= b
```

Soru metni "12.99'dan **büyük eşit**" (dahil) ama "16.99'dan **küçük**" (hariç) diyor.
`BETWEEN` üst sınırı hariç tutamadığı için iki koşul tam olarak örtüşmüyor:

| Sorgu | Anlamı | Dönen satır |
|---|---|---|
| `BETWEEN 12.99 AND 16.99` | `>= 12.99` ve `<= 16.99` | **236** |
| `BETWEEN 12.99 AND 15.99` | `>= 12.99` ve `< 16.99` | **198** |

Fark, `replacement_cost = 16.99` olan **38 filmden** geliyor:

| replacement_cost | film sayısı |
|---|---|
| 12.99 | 55 |
| 13.99 | 55 |
| 14.99 | 51 |
| 15.99 | 37 |
| 16.99 | 38 ← sadece ilk sorguda var |

Ödevde `BETWEEN` kullanımı istendiği için birinci sorgu ana cevaptır; birebir
aralık isteniyorsa `BETWEEN 12.99 AND 15.99` yazılır. `replacement_cost`
değerleri 9.99'dan 29.99'a kadar birer birer arttığı için bu iki yazım aynı
sonucu verir.

---

## Soru 2 — `actor` tablosunda `IN` ile isim filtresi

```sql
SELECT first_name,
       last_name
FROM actor
WHERE first_name IN ('Penelope', 'Nick', 'Ed');
```

`IN`, uzun `OR` zincirinin kısa yazımıdır — aşağıdaki iki sorgu birebir aynıdır:

```sql
WHERE first_name IN ('Penelope', 'Nick', 'Ed')
WHERE first_name = 'Penelope' OR first_name = 'Nick' OR first_name = 'Ed'
```

**Sonuç:** 10 satır.

| first_name | last_name |
|---|---|
| Ed | Chase |
| Ed | Guiness |
| Ed | Mansfield |
| Nick | Degeneres |
| Nick | Stallone |
| Nick | Wahlberg |
| Penelope | Cronyn |
| Penelope | Guiness |
| Penelope | Monroe |
| Penelope | Pinkett |

---

## Soru 3 — İki sütunda birlikte `IN`

```sql
SELECT *
FROM film
WHERE rental_rate      IN (0.99, 2.99, 4.99)
  AND replacement_cost IN (12.99, 15.99, 28.99);
```

İki `IN` listesi `AND` ile bağlandığı için her iki koşulun da sağlanması gerekir.
Burada `AND`/`OR` önceliği sorunu yaşanmaz — `IN` listeleri zaten kendi içinde
parantezlidir. Ödev 1'in 3. sorusundaki parantez problemi bu yüzden `IN` ile
tamamen ortadan kalkar.

**Sonuç:** 133 satır. Kombinasyon kırılımı:

| rental_rate | replacement_cost | film sayısı |
|---|---|---|
| 0.99 | 12.99 | 22 |
| 0.99 | 15.99 | 11 |
| 0.99 | 28.99 | 15 |
| 2.99 | 12.99 | 15 |
| 2.99 | 15.99 | 14 |
| 2.99 | 28.99 | 11 |
| 4.99 | 12.99 | 18 |
| 4.99 | 15.99 | 12 |
| 4.99 | 28.99 | 15 |
| | **Toplam** | **133** |

`rental_rate` sütunu `dvdrental`'da yalnızca 0.99 / 2.99 / 4.99 değerlerini
aldığından, ilk `IN` koşulu pratikte hiçbir satırı elemez — sonucu belirleyen
`replacement_cost` koşuludur.

---

## Özet

| Soru | Konu | Dönen satır |
|---|---|---|
| 1 | `BETWEEN … AND` (sınırlar dahil) | 236 (kesin aralık: 198) |
| 2 | `IN` ile metin listesi | 10 |
| 3 | İki sütunda `IN` + `AND` | 133 |
