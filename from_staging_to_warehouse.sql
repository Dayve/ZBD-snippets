
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
/

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

