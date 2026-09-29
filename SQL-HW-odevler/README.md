# SQL Ödevleri

Bu repo SQL ödev çözümlerini içerir. Tüm sorgular **PostgreSQL 16** üzerinde,
`dvdrental` örnek veritabanı ile gerçekten çalıştırılarak doğrulanmıştır —
README'lerdeki satır sayıları ve sonuç tabloları bu çalıştırmalardan alınmıştır.

## Ödevler

| Ödev | Konu | Sorgu yapıları |
|------|------|----------------|
| [Ödev 1](odev-01/) | Temel `SELECT` ve `WHERE` | `SELECT`, `AND`, `OR`, `NOT`, operatör önceliği |
| [Ödev 2](odev-02/) | `BETWEEN` ve `IN` | `BETWEEN … AND`, `IN` |
| [Ödev 3](odev-03/) | Desen arama | `LIKE`, `ILIKE`, `%`, `_` |
| [Ödev 4](odev-04/) | Tekil değerler ve sayma | `DISTINCT`, `COUNT`, `count(DISTINCT …)` |
| [Ödev 5](odev-05/) | Sıralama ve sayfalama | `ORDER BY`, `LIMIT`, `OFFSET` |
| [Ödev 6](odev-06/) | Toplama fonksiyonları | `AVG`, `COUNT`, `MAX`, `MIN` |
| [Ödev 7](odev-07/) | Gruplama | `GROUP BY`, `HAVING` |
| [Ödev 8](odev-08/) | Tablo ve veri işlemleri | `CREATE TABLE`, `INSERT`, `UPDATE`, `DELETE` |
| [Ödev 9](odev-09/) | İç birleştirme | `INNER JOIN`, `USING`, alias |
| [Ödev 10](odev-10/) | Dış birleştirmeler | `LEFT JOIN`, `RIGHT JOIN`, `FULL JOIN` |
| [Ödev 11](odev-11/) | Küme operatörleri | `UNION`, `INTERSECT`, `EXCEPT` (+ `ALL`) |
| [Ödev 12](odev-12/) | Alt sorgular | Skaler alt sorgu, `HAVING` + alt sorgu |

## Klasör Yapısı

Her ödev kendi klasöründe, üç dosya hâlinde tutulur:

```
odev-NN/
  soru.md      # Ödev metni / sorular
  cozum.sql    # Çalıştırılabilir SQL çözümleri
  README.md    # Soru soru açıklama, sonuç tabloları, dikkat edilecek noktalar
```

## Çözümleri Çalıştırma

Ödev 8 dışındaki tüm çözümler `dvdrental` veritabanı üzerinde çalışır:

```bash
psql -d dvdrental -f odev-01/cozum.sql
```

Ödev 8 kendi tablosunu oluşturur ve `test` veritabanında çalışır:

```bash
createdb test
psql -d test -f odev-08/cozum.sql
```

### `dvdrental` veritabanını kurma

```bash
createdb dvdrental
pg_restore -d dvdrental dvdrental.tar
```
