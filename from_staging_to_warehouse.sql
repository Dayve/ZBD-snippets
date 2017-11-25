
CREATE OR REPLACE FUNCTION DODAJ_CZAS
    (timestamp_dla_czasu IN timestamp)
    RETURN NUMBER
IS
    zwracany_id NUMBER;
BEGIN
	INSERT INTO zbd_warehouse.Czas (data, godzina, dzien_tygodnia, miesiac, kwartal, rok)
	VALUES (
		TO_DATE(TO_CHAR(timestamp_dla_czasu, 'YYYY-MON-DD HH24:MI:SS'), 'YYYY-MON-DD HH24:MI:SS'),
		extract(hour from timestamp_dla_czasu),
		TO_CHAR(timestamp_dla_czasu, 'Day'),
		extract(month from timestamp_dla_czasu),
		TO_NUMBER(TO_CHAR(timestamp_dla_czasu, 'Q')),
		extract(year from timestamp_dla_czasu)
	)
	RETURNING zbd_warehouse.Czas.id INTO zwracany_id;

    RETURN zwracany_id;
END;


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
INSERT INTO zbd_warehouse.promocja (id, przedzial_procentowy_obnizki)
SELECT id, obniżka_procentowa
FROM zbd_staging.promocje;

INSERT INTO zbd_warehouse.promocja (id, przedzial_kwoty_sumarycznej) VALUES (1, '0 - 5%');
INSERT INTO zbd_warehouse.promocja (id, przedzial_kwoty_sumarycznej) VALUES (2, '5 - 10%');
INSERT INTO zbd_warehouse.promocja (id, przedzial_kwoty_sumarycznej) VALUES (2, '10 - 15%');
INSERT INTO zbd_warehouse.promocja (id, przedzial_kwoty_sumarycznej) VALUES (3, '15 - 20%');
INSERT INTO zbd_warehouse.promocja (id, przedzial_kwoty_sumarycznej) VALUES (4, '20 - 25%');
INSERT INTO zbd_warehouse.promocja (id, przedzial_kwoty_sumarycznej) VALUES (5, '25 - 30%');
INSERT INTO zbd_warehouse.promocja (id, przedzial_kwoty_sumarycznej) VALUES (6, '30 - 35%');
INSERT INTO zbd_warehouse.promocja (id, przedzial_kwoty_sumarycznej) VALUES (7, '35 - 40%');
INSERT INTO zbd_warehouse.promocja (id, przedzial_kwoty_sumarycznej) VALUES (8, '40 - 50%');
INSERT INTO zbd_warehouse.promocja (id, przedzial_kwoty_sumarycznej) VALUES (9, '50 - 60%');
INSERT INTO zbd_warehouse.promocja (id, przedzial_kwoty_sumarycznej) VALUES (10, '60 - 70%');
INSERT INTO zbd_warehouse.promocja (id, przedzial_kwoty_sumarycznej) VALUES (11, '70 - 80%');
INSERT INTO zbd_warehouse.promocja (id, przedzial_kwoty_sumarycznej) VALUES (12, '80 - 90%');
INSERT INTO zbd_warehouse.promocja (id, przedzial_kwoty_sumarycznej) VALUES (13, '90 - 100%');

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
INSERT INTO zbd_warehouse.wielkosc_transakcji (id, przedzial_kwoty_sumarycznej) VALUES (2, '30 - 50zł');
INSERT INTO zbd_warehouse.wielkosc_transakcji (id, przedzial_kwoty_sumarycznej) VALUES (3, '50 - 150zł');
INSERT INTO zbd_warehouse.wielkosc_transakcji (id, przedzial_kwoty_sumarycznej) VALUES (4, '150 - 300 zł');
INSERT INTO zbd_warehouse.wielkosc_transakcji (id, przedzial_kwoty_sumarycznej) VALUES (5, '300 - 500 zł');
INSERT INTO zbd_warehouse.wielkosc_transakcji (id, przedzial_kwoty_sumarycznej) VALUES (6, '500+ zł');

-- Przedział kosztu zamówienia:
INSERT INTO zbd_warehouse.przedzial_kosztu_zamowienia (id, przedzial) VALUES (1, '500 - 1000zł');
INSERT INTO zbd_warehouse.przedzial_kosztu_zamowienia (id, przedzial) VALUES (2, '1000 - 3000zł');
INSERT INTO zbd_warehouse.przedzial_kosztu_zamowienia (id, przedzial) VALUES (2, '3000 - 5000zł');
INSERT INTO zbd_warehouse.przedzial_kosztu_zamowienia (id, przedzial) VALUES (3, '5000 - 15000zł');
INSERT INTO zbd_warehouse.przedzial_kosztu_zamowienia (id, przedzial) VALUES (4, '15000 - 30000 zł');
INSERT INTO zbd_warehouse.przedzial_kosztu_zamowienia (id, przedzial) VALUES (5, '30000 - 50000 zł');
INSERT INTO zbd_warehouse.przedzial_kosztu_zamowienia (id, przedzial) VALUES (6, '50000+ zł');

--Kategoria cenowa:
INSERT INTO zbd_warehouse.kategoria_cenowa (id, przedzial_cenowy) VALUES (1, '0 - 10zł');
INSERT INTO zbd_warehouse.kategoria_cenowa (id, przedzial_cenowy) VALUES (2, '10 - 30zł');
INSERT INTO zbd_warehouse.kategoria_cenowa (id, przedzial_cenowy) VALUES (2, '30 - 50zł');
INSERT INTO zbd_warehouse.kategoria_cenowa (id, przedzial_cenowy) VALUES (3, '50 - 150zł');
INSERT INTO zbd_warehouse.kategoria_cenowa (id, przedzial_cenowy) VALUES (4, '150 - 300 zł');
INSERT INTO zbd_warehouse.kategoria_cenowa (id, przedzial_cenowy) VALUES (5, '300 - 500 zł');
INSERT INTO zbd_warehouse.kategoria_cenowa (id, przedzial_cenowy) VALUES (6, '500+ zł');

-- Działy i kategorie - Typ produktu:
CREATE OR REPLACE PROCEDURE dodaj_typy_produktow
IS
    nazwa_dzialu varchar(30);
BEGIN
    FOR wiersz IN (SELECT nazwa, id_działu FROM zbd_staging.Kategoria_Produktu) LOOP
        SELECT nazwa INTO nazwa_dzialu FROM Dział WHERE id = wiersz.id_działu;

        INSERT INTO zbd_warehouse.typ_produktu (dzial_produktu, kategoria_produktu)
        VALUES (nazwa_dzialu, wiersz.nazwa);
    END LOOP;
END;

-- Magazyn:
CREATE OR REPLACE PROCEDURE fakty_dla_magazynu
IS
    id_kategorii number;
    id_dzialu number;
    nazwa_kategorii varchar2(50);
    nazwa_dzialu varchar2(30);
    id_typu_produktu number;
    
    id_nowego_czasu number;
BEGIN
    FOR wiersz IN (SELECT id_oddziału, id_produktu, liczba_produktów, czas FROM zbd_staging.Magazyn) LOOP
        SELECT id_kategorii, id_działu INTO id_kategorii, id_dzialu FROM zbd_staging.Produkt WHERE id = wiersz.id_produktu;

        SELECT nazwa INTO nazwa_kategorii FROM zbd_staging.Kategoria_Produktu WHERE id = id_kategorii;
        SELECT nazwa INTO nazwa_dzialu FROM zbd_staging.Dział WHERE id = id_dzialu;

        SELECT id INTO id_typu_produktu FROM zbd_warehouse.typ_produktu
        WHERE kategoria_produktu = nazwa_kategorii AND dzial_produktu = nazwa_dzialu;
        
        id_nowego_czasu := DODAJ_CZAS(wiersz.czas);

        INSERT INTO zbd_warehouse.Fakty_Magazyn (Id_Produktu, Id_Typu_Produktu, Id_Lokalizacji, Id_Czasu, Liczba_Sztuk)
        VALUES (wiersz.id_produktu, id_typu_produktu, wiersz.id_oddziału, id_nowego_czasu, wiersz.liczba_produktów);
    END LOOP;
END;

EXECUTE dodaj_typy_produktow;
EXECUTE fakty_dla_magazynu;

