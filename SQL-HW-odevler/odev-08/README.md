# Ödev 8 — Tablo Oluşturma, `INSERT`, `UPDATE`, `DELETE`

**Veritabanı:** `test` (PostgreSQL 16)
**Çözüm:** [`cozum.sql`](cozum.sql) · **Soru metni:** [`soru.md`](soru.md)

Bu ödev, diğerlerinden farklı olarak `dvdrental` yerine kendi oluşturduğumuz
`test` veritabanı üzerinde çalışır. `cozum.sql` baştan sona çalıştırılabilir bir
betiktir:

```bash
createdb test
psql -d test -f cozum.sql
```

---

## Soru 1 — `employee` tablosunu oluşturma (DDL)

```sql
CREATE TABLE employee (
    id       INTEGER PRIMARY KEY,
    name     VARCHAR(50),
    birthday DATE,
    email    VARCHAR(100)
);
```

Betiğin tekrar tekrar çalıştırılabilmesi için başına `DROP TABLE IF EXISTS employee;`
eklendi — tablo yoksa hata vermek yerine bir `NOTICE` üretip devam eder.

`id` sütununa `PRIMARY KEY` kısıtı verildi. Bu kısıt iki şeyi birden garanti eder:
değer **tekrar edemez** (`UNIQUE`) ve **boş olamaz** (`NOT NULL`). Ödevde
istenmemişti ancak `id` bir kimlik sütunu olduğu için doğru olan yaklaşım budur.

### Veri tipleri hakkında

| Sütun | Tip | Not |
|---|---|---|
| `id` | `INTEGER` | 4 baytlık tam sayı (−2.147.483.648 … 2.147.483.647) |
| `name` | `VARCHAR(50)` | En fazla 50 karakter; daha uzun değer hata verir |
| `birthday` | `DATE` | Yalnızca tarih (saat bilgisi yok) |
| `email` | `VARCHAR(100)` | En fazla 100 karakter |

---

## Soru 2 — 50 adet veri ekleme (`INSERT`)

Veri seti, Mockaroo'nun şu şema alanlarıyla üretilmiştir:

| Sütun | Mockaroo alanı |
|---|---|
| `id` | Row Number |
| `name` | Full Name |
| `birthday` | Date (1968–2001 aralığı) |
| `email` | Email Address |

Tek bir `INSERT` deyiminde çoklu `VALUES` listesi kullanıldı — 50 ayrı `INSERT`
yazmaktan hem daha kısa hem de daha hızlıdır (tek işlem olarak çalışır):

```sql
INSERT INTO employee (id, name, birthday, email) VALUES
    (1, 'Olivia Whitfield', '1996-04-22', 'olivia.whitfield@example.com'),
    (2, 'Liam Crowley',     '1991-01-14', 'liam.crowley@testcorp.org'),
    ...
    (50, '...', '...', '...');
```

**Sonuç:** `INSERT 0 50` → tabloda 50 kayıt.

| id | name | birthday | email |
|---|---|---|---|
| 1 | Olivia Whitfield | 1996-04-22 | olivia.whitfield@example.com |
| 2 | Liam Crowley | 1991-01-14 | liam.crowley@testcorp.org |
| 3 | Emma Sinclair | 2001-10-08 | emma.sinclair@testcorp.org |
| 4 | Noah Wexford | 1995-12-26 | noah.wexford@sample.io |
| 5 | Ava Ravenscroft | 1999-04-01 | ava.ravenscroft@mockmail.net |
| … | … | … | … |

---

## Soru 3 — 5 adet `UPDATE` işlemi

Her `UPDATE`, **farklı bir sütunu koşul olarak** kullanıp başka sütun(lar)ı
güncelliyor:

| # | Koşul sütunu | Güncellenen | Etkilenen satır |
|---|---|---|---|
| 3.1 | `id` | `name` | 1 |
| 3.2 | `name` | `email` | 1 |
| 3.3 | `birthday` | `name` | 2 |
| 3.4 | `email` | `birthday` | 10 |
| 3.5 | `id` (aralık) | `name` + `email` | 6 |

```sql
-- 3.1 id'ye göre name güncelle
UPDATE employee SET name = 'Olivia Whitfield-Hudson' WHERE id = 1;

-- 3.2 name'e göre email güncelle
UPDATE employee SET email = 'liam.crowley@newdomain.com' WHERE name = 'Liam Crowley';

-- 3.3 birthday'e göre name güncelle (2000 sonrası doğanlara 'Jr. ' ön eki)
UPDATE employee SET name = 'Jr. ' || name WHERE birthday > DATE '2000-01-01';

-- 3.4 email'e göre birthday güncelle
UPDATE employee SET birthday = DATE '1990-06-15' WHERE email LIKE '%@sample.io';

-- 3.5 id aralığına göre iki sütunu birlikte güncelle
UPDATE employee
SET name  = 'Updated Employee',
    email = 'updated.employee@example.com'
WHERE id BETWEEN 45 AND 50;
```

### Dikkat edilmesi gereken noktalar

- **`WHERE` yazmayı asla atlamayın.** `UPDATE employee SET name = 'X';` yazarsanız
  tablodaki **tüm** satırlar güncellenir ve geri alma imkânı olmaz
  (transaction dışındaysanız).
- `||` operatörü PostgreSQL'de metin birleştirmedir: `'Jr. ' || name` mevcut
  değerin başına ekleme yapar. Bu, bir sütunu **kendi değerini kullanarak**
  güncellemeye örnektir.
- Tek `SET` içinde virgülle ayırarak birden fazla sütun güncellenebilir (3.5).
- PostgreSQL her `UPDATE` sonunda `UPDATE n` şeklinde etkilenen satır sayısını
  bildirir — beklediğiniz sayı gelmezse koşulunuz yanlıştır.

---

## Soru 4 — 5 adet `DELETE` işlemi

| # | Koşul sütunu | Silinen satır |
|---|---|---|
| 4.1 | `id` | 1 |
| 4.2 | `name` | 6 |
| 4.3 | `birthday` | 2 |
| 4.4 | `email` | 11 |
| 4.5 | `birthday` + `email` | 1 |
| | **Toplam** | **21** |

```sql
DELETE FROM employee WHERE id = 3;
DELETE FROM employee WHERE name = 'Updated Employee';
DELETE FROM employee WHERE birthday < DATE '1970-01-01';
DELETE FROM employee WHERE email LIKE '%@mockmail.net';
DELETE FROM employee
WHERE birthday BETWEEN DATE '1985-01-01' AND DATE '1989-12-31'
  AND email LIKE '%@example.com';
```

**Sonuç:** 50 − 21 = **29 kayıt** kaldı.

### Dikkat edilmesi gereken noktalar

- 4.2'de tek bir `DELETE` **6 satır** sildi. Sebebi, 3.5'teki `UPDATE`'in 6 satırın
  `name` değerini aynı `'Updated Employee'` değerine çekmiş olması. Yani
  `UPDATE` ve `DELETE` işlemleri sırayla çalışır ve önceki adım sonrakinin
  etkisini değiştirir.
- `DELETE FROM employee;` (WHERE'siz) tablodaki tüm satırları siler.
  Yapıyı da silmek için `DROP TABLE`, sadece içeriği hızlıca boşaltmak için
  `TRUNCATE` kullanılır.
- Riskli bir silme öncesi koşulu önce `SELECT` ile denemek iyi bir alışkanlıktır:

  ```sql
  SELECT * FROM employee WHERE email LIKE '%@mockmail.net';  -- önce gör
  DELETE FROM employee WHERE email LIKE '%@mockmail.net';    -- sonra sil
  ```

- Alternatif olarak transaction içinde çalışılabilir:

  ```sql
  BEGIN;
  DELETE FROM employee WHERE ...;
  -- sonucu kontrol et
  ROLLBACK;  -- yanlışsa geri al, doğruysa COMMIT;
  ```

---

## Özet

| Soru | İşlem | Sonuç |
|---|---|---|
| 1 | `CREATE TABLE` | 4 sütunlu `employee` tablosu |
| 2 | `INSERT` | 50 kayıt |
| 3 | 5 × `UPDATE` | 1 + 1 + 2 + 10 + 6 = 20 satır güncellendi |
| 4 | 5 × `DELETE` | 21 satır silindi → 29 kayıt kaldı |
