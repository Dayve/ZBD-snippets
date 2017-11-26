
-- Dostawcy:
INSERT INTO zbd_warehouse.dostawca (id, nazwa)
SELECT id, nazwa
FROM zbd_staging.dostawca;

-- Oddziały -> lokalizacje:
INSERT INTO zbd_warehouse.lokalizacja (id, wojewodztwo, miasto, oddzial)
SELECT id, województwo, miasto, nazwa
FROM zbd_staging.oddział;

-- Pracownicy:
INSERT INTO zbd_warehouse.pracownik (id, imie, nazwisko)
SELECT id, imię, nazwisko
FROM zbd_staging.pracownik;

-- Promocje: FIXME: Przedział, a nie wartość procentowa
INSERT INTO zbd_warehouse.promocja (id, od_procentowo, do_procentowo) VALUES (1, 0, 5);
INSERT INTO zbd_warehouse.promocja (id, od_procentowo, do_procentowo) VALUES (2, 5, 10);
INSERT INTO zbd_warehouse.promocja (id, od_procentowo, do_procentowo) VALUES (2, 10, 15);
INSERT INTO zbd_warehouse.promocja (id, od_procentowo, do_procentowo) VALUES (3, 15, 20);
INSERT INTO zbd_warehouse.promocja (id, od_procentowo, do_procentowo) VALUES (4, 20, 25);
INSERT INTO zbd_warehouse.promocja (id, od_procentowo, do_procentowo) VALUES (5, 25, 30);
INSERT INTO zbd_warehouse.promocja (id, od_procentowo, do_procentowo) VALUES (6, 30, 35);
INSERT INTO zbd_warehouse.promocja (id, od_procentowo, do_procentowo) VALUES (7, 35, 40);
INSERT INTO zbd_warehouse.promocja (id, od_procentowo, do_procentowo) VALUES (8, 40, 50);
INSERT INTO zbd_warehouse.promocja (id, od_procentowo, do_procentowo) VALUES (9, 50, 60);
INSERT INTO zbd_warehouse.promocja (id, od_procentowo, do_procentowo) VALUES (10, 60, 70);
INSERT INTO zbd_warehouse.promocja (id, od_procentowo, do_procentowo) VALUES (11, 70, 80);
INSERT INTO zbd_warehouse.promocja (id, od_procentowo, do_procentowo) VALUES (12, 80, 90);
INSERT INTO zbd_warehouse.promocja (id, od_procentowo, do_procentowo) VALUES (13, 90, 100);

-- Reklamacje:
INSERT INTO zbd_warehouse.reklamacja (id, powod)
SELECT id, powód
FROM zbd_staging.reklamacja;

-- Ocena:
INSERT INTO zbd_warehouse.ocena_od_klienta (id, ocena)
SELECT id, ocena
FROM zbd_staging.ocena_od_klienta;

-- Produkty:
INSERT INTO zbd_warehouse.produkt (id, nazwa)
SELECT id, nazwa
FROM zbd_staging.produkt;

-- Wielkość Transakcji:
INSERT INTO zbd_warehouse.wielkosc_transakcji (id, od_PLN, do_PLN) VALUES (1, 0, 10);
INSERT INTO zbd_warehouse.wielkosc_transakcji (id, od_PLN, do_PLN) VALUES (2, 10, 30);
INSERT INTO zbd_warehouse.wielkosc_transakcji (id, od_PLN, do_PLN) VALUES (3, 30, 50);
INSERT INTO zbd_warehouse.wielkosc_transakcji (id, od_PLN, do_PLN) VALUES (4, 50, 150);
INSERT INTO zbd_warehouse.wielkosc_transakcji (id, od_PLN, do_PLN) VALUES (5, 150, 300);
INSERT INTO zbd_warehouse.wielkosc_transakcji (id, od_PLN, do_PLN) VALUES (6, 300, 500);
INSERT INTO zbd_warehouse.wielkosc_transakcji (id, od_PLN, do_PLN) VALUES (7, 500, 1000000000);

-- Przedział kosztu zamówienia:
INSERT INTO zbd_warehouse.przedzial_kosztu_zamowienia (id, od_PLN, do_PLN) VALUES (1, 500, 1000);
INSERT INTO zbd_warehouse.przedzial_kosztu_zamowienia (id, od_PLN, do_PLN) VALUES (2, 1000, 3000);
INSERT INTO zbd_warehouse.przedzial_kosztu_zamowienia (id, od_PLN, do_PLN) VALUES (3, 3000, 5000);
INSERT INTO zbd_warehouse.przedzial_kosztu_zamowienia (id, od_PLN, do_PLN) VALUES (4, 5000, 15000);
INSERT INTO zbd_warehouse.przedzial_kosztu_zamowienia (id, od_PLN, do_PLN) VALUES (5, 15000, 30000);
INSERT INTO zbd_warehouse.przedzial_kosztu_zamowienia (id, od_PLN, do_PLN) VALUES (6, 30000, 50000);
INSERT INTO zbd_warehouse.przedzial_kosztu_zamowienia (id, od_PLN, do_PLN) VALUES (7, 50000, 1000000000);

--Kategoria cenowa:
INSERT INTO zbd_warehouse.kategoria_cenowa (id, od_PLN, do_PLN) VALUES (1, 0, 10);
INSERT INTO zbd_warehouse.kategoria_cenowa (id, od_PLN, do_PLN) VALUES (2, 10, 30);
INSERT INTO zbd_warehouse.kategoria_cenowa (id, od_PLN, do_PLN) VALUES (3, 30, 50);
INSERT INTO zbd_warehouse.kategoria_cenowa (id, od_PLN, do_PLN) VALUES (4, 50, 150);
INSERT INTO zbd_warehouse.kategoria_cenowa (id, od_PLN, do_PLN) VALUES (5, 150, 300);
INSERT INTO zbd_warehouse.kategoria_cenowa (id, od_PLN, do_PLN) VALUES (6, 300, 500);
INSERT INTO zbd_warehouse.kategoria_cenowa (id, od_PLN, do_PLN) VALUES (7, 500, 1000000000);


EXECUTE dodaj_typy_produktow;
EXECUTE fakty_dla_magazynu;

