# Ödev 3 — `LIKE` / `ILIKE` ve Joker Karakterler

**Veritabanı:** `dvdrental` (PostgreSQL 16)
**Çözüm:** [`cozum.sql`](cozum.sql) · **Soru metni:** [`soru.md`](soru.md)

## Joker karakter hatırlatması

| Karakter | Anlamı |
|---|---|
| `%` | Sıfır veya daha fazla karakter |
| `_` | Tam olarak **bir** karakter |

`LIKE` büyük/küçük harfe **duyarlıdır**, `ILIKE` (PostgreSQL'e özgü) duyarlı değildir.

---

## Soru 1 — 'A' ile başlayıp 'a' ile biten ülkeler

```sql
SELECT country
FROM country
WHERE country LIKE 'A%a';
```

Desen `A` + (herhangi sayıda karakter) + `a` şeklinde okunur. Baştaki `A` büyük,
sondaki `a` küçük olduğu için `LIKE` yeterlidir — `ILIKE` kullanılsaydı
`'Argentina'` gibi kayıtların yanında baş harfi küçük yazılmış kayıtlar da gelirdi.

**Sonuç:** 8 satır.

| country |
|---|
| Algeria |
| American Samoa |
| Angola |
| Anguilla |
| Argentina |
| Armenia |
| Australia |
| Austria |

---

## Soru 2 — En az 6 karakterli, 'n' ile biten ülkeler

```sql
SELECT country
FROM country
WHERE country LIKE '_____%n';
```

Desenin mantığı:

```
_____   →  herhangi 5 karakter (hepsi zorunlu)
%       →  0 veya daha fazla karakter
n       →  son karakter 'n'
────────────────────────────────
         en az 5 + 1 = 6 karakter
```

`length()` fonksiyonuyla yazılmış, okunması daha kolay eşdeğeri (yine 12 satır):

```sql
SELECT country
FROM country
WHERE country LIKE '%n'
  AND length(country) >= 6;
```

**Sonuç:** 12 satır.

| country | karakter sayısı |
|---|---|
| Afghanistan | 11 |
| Azerbaijan | 10 |
| Bahrain | 7 |
| Cameroon | 8 |
| Kazakstan | 9 |
| Liechtenstein | 13 |
| Pakistan | 8 |
| Runion | 6 |
| Russian Federation | 18 |
| Sweden | 6 |
| Taiwan | 6 |
| Turkmenistan | 12 |

> En kısa üç kayıt (`Runion`, `Sweden`, `Taiwan`) tam 6 karakter — desenin alt
> sınırını doğru kurduğumuzu gösteriyor.

---

## Soru 3 — İçinde en az 4 adet 'T'/'t' geçen film isimleri

```sql
SELECT title
FROM film
WHERE title ILIKE '%t%t%t%t%';
```

Desen, aralarında başka karakterler olabilecek şekilde **en az 4 kez** `t`
geçmesini şart koşar. Büyük/küçük harf farkı aranmadığı için `LIKE` yerine
`ILIKE` kullanıldı.

**Sonuç:** 9 satır.

| title | 't' sayısı |
|---|---|
| Antitrust Tomatoes | 5 |
| Entrapment Satisfaction | 5 |
| Desperate Trainspotting | 4 |
| Attraction Newton | 4 |
| Haunted Antitrust | 4 |
| Potter Connecticut | 4 |
| Streetcar Intentions | 4 |
| Temple Attraction | 4 |
| Trainspotting Strangers | 4 |

> `LIKE` (ILIKE yerine) kullanılsaydı `'Antitrust Tomatoes'` gibi baştaki büyük
> `T`'yi barındıran kayıtlar eksik sayılır ve sonuç değişirdi.

---

## Soru 4 — Üç koşulun birleşimi

```sql
SELECT *
FROM film
WHERE title LIKE 'C%'
  AND length > 90
  AND rental_rate = 2.99;
```

Üç koşul da `AND` ile bağlı olduğu için parantez gerekmez (`AND` zinciri
birleşmelidir/associative). `LIKE 'C%'` deseni yalnızca baş harfi kontrol eder.

**Sonuç:** 20 satır. Bir kesit:

| film_id | title | length | rental_rate |
|---|---|---|---|
| 115 | Campus Remember | 167 | 2.99 |
| 121 | Carol Texas | 151 | 2.99 |
| 129 | Cause Date | 179 | 2.99 |
| 136 | Chaplin License | 146 | 2.99 |
| 146 | Chitty Lock | 107 | 2.99 |
| 162 | Clueless Bucket | 95 | 2.99 |
| 184 | Core Suit | 92 | 2.99 |
| … | … | … | … |

---

## Özet

| Soru | Desen | Dönen satır |
|---|---|---|
| 1 | `LIKE 'A%a'` | 8 |
| 2 | `LIKE '_____%n'` | 12 |
| 3 | `ILIKE '%t%t%t%t%'` | 9 |
| 4 | `LIKE 'C%'` + 2 koşul | 20 |
