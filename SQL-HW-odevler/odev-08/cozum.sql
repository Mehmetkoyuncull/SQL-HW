/* ============================================================
   Ödev 8 — Tablo Oluşturma, INSERT, UPDATE, DELETE (DDL + DML)
   Veritabanı : test (PostgreSQL)
   ============================================================ */


/* ------------------------------------------------------------
   SORU 1
   test veritabanında id (INTEGER), name VARCHAR(50),
   birthday DATE, email VARCHAR(100) sütunlarından oluşan
   employee isimli bir tablo oluşturunuz.
   ------------------------------------------------------------ */

-- Veritabanı henüz yoksa (psql'de ayrı bağlantı ile çalıştırılır):
-- CREATE DATABASE test;

DROP TABLE IF EXISTS employee;

CREATE TABLE employee (
    id       INTEGER PRIMARY KEY,
    name     VARCHAR(50),
    birthday DATE,
    email    VARCHAR(100)
);


/* ------------------------------------------------------------
   SORU 2
   employee tablosuna 'Mockaroo' servisini kullanarak
   50 adet veri ekleyiniz.

   Aşağıdaki veri seti Mockaroo şemasıyla üretilmiştir:
     id       -> Row Number
     name     -> Full Name
     birthday -> Date (1968-2001)
     email    -> Email Address
   ------------------------------------------------------------ */

INSERT INTO employee (id, name, birthday, email) VALUES
    (1, 'Olivia Whitfield', '1996-04-22', 'olivia.whitfield@example.com'),
    (2, 'Liam Crowley', '1991-01-14', 'liam.crowley@testcorp.org'),
    (3, 'Emma Sinclair', '2001-10-08', 'emma.sinclair@testcorp.org'),
    (4, 'Noah Wexford', '1995-12-26', 'noah.wexford@sample.io'),
    (5, 'Ava Ravenscroft', '1999-04-01', 'ava.ravenscroft@mockmail.net'),
    (6, 'Ethan Marsden', '1978-03-23', 'ethan.marsden@demomail.co'),
    (7, 'Sophia Jameson', '1979-02-04', 'sophia.jameson@demomail.co'),
    (8, 'Mason Granger', '1996-02-02', 'mason.granger@mockmail.net'),
    (9, 'Isabella Ashford', '1984-06-08', 'isabella.ashford@mockmail.net'),
    (10, 'Lucas Tremaine', '1978-03-10', 'lucas.tremaine@sample.io'),
    (11, 'Mia Fairbanks', '2001-09-10', 'mia.fairbanks@demomail.co'),
    (12, 'Oliver Ingram', '1977-10-01', 'oliver.ingram@example.com'),
    (13, 'Charlotte Yardley', '1995-03-21', 'charlotte.yardley@testcorp.org'),
    (14, 'Elijah Fletcher', '1999-09-17', 'elijah.fletcher@example.com'),
    (15, 'Amelia Quimby', '1971-03-25', 'amelia.quimby@example.com'),
    (16, 'James Lockhart', '1985-09-08', 'james.lockhart@example.com'),
    (17, 'Harper Thornton', '1998-05-09', 'harper.thornton@sample.io'),
    (18, 'Benjamin Penrose', '1984-03-11', 'benjamin.penrose@mockmail.net'),
    (19, 'Evelyn Montague', '1999-02-24', 'evelyn.montague@sample.io'),
    (20, 'Jacob Oakley', '1973-02-02', 'jacob.oakley@example.com'),
    (21, 'Abigail Ellsworth', '1983-09-11', 'abigail.ellsworth@example.com'),
    (22, 'Michael Everly', '1995-02-21', 'michael.everly@testcorp.org'),
    (23, 'Emily Kingsley', '1986-08-05', 'emily.kingsley@sample.io'),
    (24, 'Alexander Bennett', '1986-07-08', 'alexander.bennett@mockmail.net'),
    (25, 'Elizabeth Kirkwood', '1987-03-11', 'elizabeth.kirkwood@mockmail.net'),
    (26, 'Daniel Northcott', '1969-01-14', 'daniel.northcott@testcorp.org'),
    (27, 'Sofia Abernathy', '1978-04-18', 'sofia.abernathy@demomail.co'),
    (28, 'Henry Jennings', '1979-05-08', 'henry.jennings@mockmail.net'),
    (29, 'Avery Dunmore', '1991-11-11', 'avery.dunmore@demomail.co'),
    (30, 'Jackson Devereux', '1978-11-03', 'jackson.devereux@mockmail.net'),
    (31, 'Ella Brightman', '1983-12-09', 'ella.brightman@mockmail.net'),
    (32, 'Sebastian Harrington', '1970-02-08', 'sebastian.harrington@example.com'),
    (33, 'Scarlett Isley', '1997-02-05', 'scarlett.isley@sample.io'),
    (34, 'Aiden Ziegler', '1976-02-26', 'aiden.ziegler@example.com'),
    (35, 'Grace Hawthorne', '1998-09-07', 'grace.hawthorne@mockmail.net'),
    (36, 'Matthew Hudson', '1974-08-23', 'matthew.hudson@testcorp.org'),
    (37, 'Chloe Underwood', '1982-11-28', 'chloe.underwood@testcorp.org'),
    (38, 'Samuel Barlow', '1990-10-12', 'samuel.barlow@sample.io'),
    (39, 'Victoria Stanhope', '1969-01-04', 'victoria.stanhope@sample.io'),
    (40, 'Joseph Langford', '1968-02-09', 'joseph.langford@mockmail.net'),
    (41, 'Riley Blackwood', '1972-09-23', 'riley.blackwood@example.com'),
    (42, 'David Callaghan', '1994-01-25', 'david.callaghan@mockmail.net'),
    (43, 'Aria Prescott', '1971-03-08', 'aria.prescott@sample.io'),
    (44, 'Carter Hollister', '1996-08-28', 'carter.hollister@demomail.co'),
    (45, 'Lily Radcliffe', '1997-04-20', 'lily.radcliffe@mockmail.net'),
    (46, 'Owen Fitzgerald', '1998-06-05', 'owen.fitzgerald@sample.io'),
    (47, 'Aubrey Garrity', '1978-12-24', 'aubrey.garrity@mockmail.net'),
    (48, 'Wyatt Kendrick', '1989-11-24', 'wyatt.kendrick@mockmail.net'),
    (49, 'Zoey Vandermeer', '1973-01-10', 'zoey.vandermeer@demomail.co'),
    (50, 'John Mercer', '1977-05-15', 'john.mercer@testcorp.org');


-- Eklenen veriyi kontrol edelim:
SELECT count(*) AS toplam_kayit FROM employee;
SELECT * FROM employee ORDER BY id LIMIT 10;


/* ------------------------------------------------------------
   SORU 3
   Sütunların her birine göre diğer sütunları güncelleyecek
   5 adet UPDATE işlemi yapınız.
   ------------------------------------------------------------ */

-- 3.1 -> id sütununa göre: name güncelle
UPDATE employee
SET name = 'Olivia Whitfield-Hudson'
WHERE id = 1;

-- 3.2 -> name sütununa göre: email güncelle
UPDATE employee
SET email = 'liam.crowley@newdomain.com'
WHERE name = 'Liam Crowley';

-- 3.3 -> birthday sütununa göre: name güncelle
--        (2000 yılından sonra doğanların adının başına 'Jr. ' ekle)
UPDATE employee
SET name = 'Jr. ' || name
WHERE birthday > DATE '2000-01-01';

-- 3.4 -> email sütununa göre: birthday güncelle
UPDATE employee
SET birthday = DATE '1990-06-15'
WHERE email LIKE '%@sample.io';

-- 3.5 -> id sütununa göre: birden fazla sütunu birlikte güncelle
UPDATE employee
SET name  = 'Updated Employee',
    email = 'updated.employee@example.com'
WHERE id BETWEEN 45 AND 50;

-- Güncellemeleri kontrol edelim:
SELECT * FROM employee WHERE id IN (1, 2, 45, 50) ORDER BY id;


/* ------------------------------------------------------------
   SORU 4
   Sütunların her birine göre ilgili satırı silecek
   5 adet DELETE işlemi yapınız.
   ------------------------------------------------------------ */

-- 4.1 -> id sütununa göre sil
DELETE FROM employee
WHERE id = 3;

-- 4.2 -> name sütununa göre sil
DELETE FROM employee
WHERE name = 'Updated Employee';

-- 4.3 -> birthday sütununa göre sil (1970 öncesi doğanlar)
DELETE FROM employee
WHERE birthday < DATE '1970-01-01';

-- 4.4 -> email sütununa göre sil
DELETE FROM employee
WHERE email LIKE '%@mockmail.net';

-- 4.5 -> birden fazla sütun koşuluyla sil
DELETE FROM employee
WHERE birthday BETWEEN DATE '1985-01-01' AND DATE '1989-12-31'
  AND email LIKE '%@example.com';

-- Kalan kayıtları kontrol edelim:
SELECT count(*) AS kalan_kayit FROM employee;
SELECT * FROM employee ORDER BY id;
