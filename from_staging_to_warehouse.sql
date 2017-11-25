
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
INSERT INTO zbd_warehouse.promocja (id, przedzial_procentowy_obnizki) VALUES (1, '0 - 5%');
INSERT INTO zbd_warehouse.promocja (id, przedzial_procentowy_obnizki) VALUES (2, '5 - 10%');
INSERT INTO zbd_warehouse.promocja (id, przedzial_procentowy_obnizki) VALUES (2, '10 - 15%');
INSERT INTO zbd_warehouse.promocja (id, przedzial_procentowy_obnizki) VALUES (3, '15 - 20%');
INSERT INTO zbd_warehouse.promocja (id, przedzial_procentowy_obnizki) VALUES (4, '20 - 25%');
INSERT INTO zbd_warehouse.promocja (id, przedzial_procentowy_obnizki) VALUES (5, '25 - 30%');
INSERT INTO zbd_warehouse.promocja (id, przedzial_procentowy_obnizki) VALUES (6, '30 - 35%');
INSERT INTO zbd_warehouse.promocja (id, przedzial_procentowy_obnizki) VALUES (7, '35 - 40%');
INSERT INTO zbd_warehouse.promocja (id, przedzial_procentowy_obnizki) VALUES (8, '40 - 50%');
INSERT INTO zbd_warehouse.promocja (id, przedzial_procentowy_obnizki) VALUES (9, '50 - 60%');
INSERT INTO zbd_warehouse.promocja (id, przedzial_procentowy_obnizki) VALUES (10, '60 - 70%');
INSERT INTO zbd_warehouse.promocja (id, przedzial_procentowy_obnizki) VALUES (11, '70 - 80%');
INSERT INTO zbd_warehouse.promocja (id, przedzial_procentowy_obnizki) VALUES (12, '80 - 90%');
INSERT INTO zbd_warehouse.promocja (id, przedzial_procentowy_obnizki) VALUES (13, '90 - 100%');

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
INSERT INTO zbd_warehouse.wielkosc_transakcji (id, przedzial_kwoty_sumarycznej) VALUES (1, '0 - 10zł');
INSERT INTO zbd_warehouse.wielkosc_transakcji (id, przedzial_kwoty_sumarycznej) VALUES (2, '10 - 30zł');
INSERT INTO zbd_warehouse.wielkosc_transakcji (id, przedzial_kwoty_sumarycznej) VALUES (3, '30 - 50zł');
INSERT INTO zbd_warehouse.wielkosc_transakcji (id, przedzial_kwoty_sumarycznej) VALUES (4, '50 - 150zł');
INSERT INTO zbd_warehouse.wielkosc_transakcji (id, przedzial_kwoty_sumarycznej) VALUES (5, '150 - 300 zł');
INSERT INTO zbd_warehouse.wielkosc_transakcji (id, przedzial_kwoty_sumarycznej) VALUES (6, '300 - 500 zł');
INSERT INTO zbd_warehouse.wielkosc_transakcji (id, przedzial_kwoty_sumarycznej) VALUES (7, '500+ zł');

-- Przedział kosztu zamówienia:
INSERT INTO zbd_warehouse.przedzial_kosztu_zamowienia (id, przedzial) VALUES (1, '500 - 1000zł');
INSERT INTO zbd_warehouse.przedzial_kosztu_zamowienia (id, przedzial) VALUES (2, '1000 - 3000zł');
INSERT INTO zbd_warehouse.przedzial_kosztu_zamowienia (id, przedzial) VALUES (3, '3000 - 5000zł');
INSERT INTO zbd_warehouse.przedzial_kosztu_zamowienia (id, przedzial) VALUES (4, '5000 - 15000zł');
INSERT INTO zbd_warehouse.przedzial_kosztu_zamowienia (id, przedzial) VALUES (5, '15000 - 30000 zł');
INSERT INTO zbd_warehouse.przedzial_kosztu_zamowienia (id, przedzial) VALUES (6, '30000 - 50000 zł');
INSERT INTO zbd_warehouse.przedzial_kosztu_zamowienia (id, przedzial) VALUES (7, '50000+ zł');

--Kategoria cenowa:
INSERT INTO zbd_warehouse.kategoria_cenowa (id, przedzial_cenowy) VALUES (1, '0 - 10zł');
INSERT INTO zbd_warehouse.kategoria_cenowa (id, przedzial_cenowy) VALUES (2, '10 - 30zł');
INSERT INTO zbd_warehouse.kategoria_cenowa (id, przedzial_cenowy) VALUES (3, '30 - 50zł');
INSERT INTO zbd_warehouse.kategoria_cenowa (id, przedzial_cenowy) VALUES (4, '50 - 150zł');
INSERT INTO zbd_warehouse.kategoria_cenowa (id, przedzial_cenowy) VALUES (5, '150 - 300 zł');
INSERT INTO zbd_warehouse.kategoria_cenowa (id, przedzial_cenowy) VALUES (6, '300 - 500 zł');
INSERT INTO zbd_warehouse.kategoria_cenowa (id, przedzial_cenowy) VALUES (7, '500+ zł');


EXECUTE dodaj_typy_produktow;
EXECUTE fakty_dla_magazynu;

