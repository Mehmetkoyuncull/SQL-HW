# Ödev 11 — Küme Operatörleri: `UNION` / `INTERSECT` / `EXCEPT`

**Veritabanı:** `dvdrental` (PostgreSQL 16)
**Çözüm:** [`cozum.sql`](cozum.sql) · **Soru metni:** [`soru.md`](soru.md)

Küme operatörleri, iki `SELECT` sorgusunun **sonuçlarını** birleştirir.
`JOIN`'den farkı: `JOIN` satırları **yan yana** ekler (sütun sayısı artar),
küme operatörleri ise **alt alta** ekler (satır sayısı artar).

| Operatör | Küme karşılığı | Ne döndürür? |
|---|---|---|
| `UNION` | A ∪ B | İki sorgudaki tüm değerler |
| `INTERSECT` | A ∩ B | Yalnızca her ikisinde de olanlar |
| `EXCEPT` | A \ B | Birincide olup ikincide olmayanlar |

**Kural:** İki `SELECT`'in sütun sayısı eşit, veri tipleri uyumlu olmalıdır.

**Varsayılan davranış:** Üç operatör de **tekrarları siler**. Sonuna `ALL`
eklenirse tekrarlar korunur.

## Başlangıç verisi

| Tablo | Satır sayısı | Farklı `first_name` sayısı |
|---|---|---|
| `actor` | 200 | 128 |
| `customer` | 599 | 591 |

`actor` tablosunda 200 satır var ama yalnızca 128 farklı ad — yani aynı ad birden
fazla oyuncuda tekrar ediyor (`Penelope` 4 kez, `Julia` 4 kez, `Kenneth` 4 kez…).
Bu tekrarlar 4. sorunun cevabını doğrudan etkiliyor.

---

## Soru 1 — Tüm veriler (`UNION`)

```sql
SELECT first_name FROM actor
UNION
SELECT first_name FROM customer
ORDER BY first_name;
```

**Sonuç:** 647 satır.

Kontrol: 128 (actor'daki farklı ad) + 591 (customer'daki farklı ad) − 72 (ortak ad)
= **647** ✓

---

## Soru 2 — Kesişen veriler (`INTERSECT`)

```sql
SELECT first_name FROM actor
INTERSECT
SELECT first_name FROM customer
ORDER BY first_name;
```

Hem oyuncu hem müşteri isimlerinde geçen adlar.

**Sonuç:** 72 satır.

İlk on kayıt: `Adam`, `Alan`, `Albert`, `Angela`, `Anne`, `Audrey`, `Ben`, `Bob`,
`Carmen`, `Chris`, …

---

## Soru 3 — Birincide olup ikincide olmayanlar (`EXCEPT`)

```sql
SELECT first_name FROM actor
EXCEPT
SELECT first_name FROM customer
ORDER BY first_name;
```

Oyuncularda geçen ama hiçbir müşteride geçmeyen adlar.

**Sonuç:** 56 satır. Kontrol: 128 − 72 = **56** ✓

```
Al, Alec, Angelina, Bela, Bette, Burt, Cameron, Cary, Cate, Charlize, Cuba, Ed,
Elvis, Ewan, Fay, Geoffrey, Goldie, Greta, Groucho, Harrison, Humphrey, Jada,
Jayne, Jodie, Jude, Julianne, Kirsten, Laurence, Liza, Meg, Mena, Meryl, Milla,
Morgan, Nick, Olympia, Oprah, Parker, Penelope, Reese, Rip, River, Rock, Salma,
Scarlett, Sissy, Spencer, Sylvester, Thora, Uma, Val, Vivien, Whoopi, Will,
Woody, Zero
```

> Liste Hollywood oyuncu isimlerinden oluşuyor (`Penelope`, `Uma`, `Whoopi`,
> `Sylvester`…) — `actor` tablosunun gerçek oyuncu adlarından üretilmiş olması ve
> müşteri isimlerinin daha sıradan adlardan gelmesi bu farkı doğuruyor.

### `EXCEPT` simetrik değildir

`A EXCEPT B` ile `B EXCEPT A` **farklı** sonuç verir. Ters yönde
(`customer EXCEPT actor`) 591 − 72 = 519 ad dönerdi. Soru "ilk tabloda bulunan
ancak ikinci tabloda bulunmayan" dediği için `actor` sorgusu başa yazılmalıdır.

---

## Soru 4 — Aynı üç sorgunun `ALL` ile tekrarları koruyan hâli

### `ALL` eklenince davranış nasıl değişir?

| Operatör | Bir değer A'da *m*, B'de *n* kez geçiyorsa sonuçta kaç kez yer alır? |
|---|---|
| `UNION` | 1 kez |
| `UNION ALL` | *m + n* kez |
| `INTERSECT` | 1 kez (her ikisinde varsa) |
| `INTERSECT ALL` | **min(*m*, *n*)** kez |
| `EXCEPT` | 1 kez (A'da varsa, B'de yoksa) |
| `EXCEPT ALL` | **max(*m* − *n*, 0)** kez |

### 4.1 — `UNION ALL`

```sql
SELECT first_name FROM actor
UNION ALL
SELECT first_name FROM customer;
```

**Sonuç:** 799 satır = 200 + 599 (hiçbir satır silinmez, iki tablo olduğu gibi
alt alta eklenir).

> `UNION ALL`, `UNION`'dan **daha hızlıdır** çünkü tekrarları bulup silmek için
> sıralama/hashleme yapması gerekmez. Tekrar olmayacağını biliyorsanız veya
> tekrarlar sorun değilse `UNION ALL` tercih edilmelidir.

### 4.2 — `INTERSECT ALL`

```sql
SELECT first_name FROM actor
INTERSECT ALL
SELECT first_name FROM customer;
```

**Sonuç:** 72 satır.

`INTERSECT` ile aynı sayı çıktı — ama bu bir tesadüf değil, verinin yapısından
kaynaklanıyor: kesişen 72 adın neredeyse tamamı `customer` tablosunda yalnızca
**1 kez** geçiyor. `min(m, n)` formülünde `n = 1` olduğunda katkı 1 olur, yani
sonuç tekil listeyle aynı büyüklükte kalır.

### 4.3 — `EXCEPT ALL`

```sql
SELECT first_name FROM actor
EXCEPT ALL
SELECT first_name FROM customer;
```

**Sonuç:** 128 satır — `EXCEPT`'in döndürdüğü 56 satırın **iki katından fazla**.

Farkın nedeni `actor` tablosundaki tekrarlar. `max(m − n, 0)` formülünün nasıl
çalıştığını birkaç örnekle görelim:

| first_name | actor'da (*m*) | customer'da (*n*) | `INTERSECT ALL` katkısı: min(m,n) | `EXCEPT ALL` katkısı: max(m−n,0) |
|---|---|---|---|---|
| Julia | 4 | 1 | 1 | **3** |
| Kenneth | 4 | 1 | 1 | **3** |
| Penelope | 4 | 0 | 0 | **4** |
| Burt | 3 | 0 | 0 | **3** |
| Christian | 3 | 1 | 1 | **2** |
| Dan | 3 | 1 | 1 | **2** |
| … | … | … | … | … |
| | | **Toplam** | **72** ✓ | **128** ✓ |

Örneğin `Julia` adı 4 oyuncuda, 1 müşteride geçiyor. `EXCEPT` bu adı hiç
döndürmez (çünkü müşterilerde de var); `EXCEPT ALL` ise 4 − 1 = **3 kez**
döndürür. `Penelope` müşterilerde hiç geçmediği için `EXCEPT` 1 kez,
`EXCEPT ALL` ise 4 kez döndürür.

---

## Tüm sonuçlar bir arada

| Sorgu | Dönen satır |
|---|---|
| `UNION` | 647 |
| `UNION ALL` | 799 |
| `INTERSECT` | 72 |
| `INTERSECT ALL` | 72 |
| `EXCEPT` | 56 |
| `EXCEPT ALL` | 128 |
