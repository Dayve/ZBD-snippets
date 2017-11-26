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
/

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
/


CREATE OR REPLACE FUNCTION ID_PRZEDZIALU_DLA_DANEJ_SPRZEDAZY
    (dany_numer_transakcji IN NUMBER)
    RETURN NUMBER
IS
    sumaryczna_kwota NUMBER;
    id_przedzialu_wielkosci NUMBER;
BEGIN
	SELECT sum(cena*zbd_staging.Sprzedaż.liczba_produktów) INTO sumaryczna_kwota
	FROM zbd_staging.cena_produktu
	LEFT JOIN zbd_staging.Sprzedaż
	ON zbd_staging.cena_produktu.id_produktu = zbd_staging.Sprzedaż.id_produktu
	WHERE zbd_staging.Sprzedaż.czas BETWEEN zbd_staging.cena_produktu.od AND zbd_staging.cena_produktu.do
	AND zbd_staging.Sprzedaż.numer_transakcji = dany_numer_transakcji
	GROUP BY zbd_staging.Sprzedaż.numer_transakcji;

	SELECT id INTO id_przedzialu_wielkosci FROM zbd_warehouse.wielkosc_transakcji
	WHERE sumaryczna_kwota >= zbd_warehouse.wielkosc_transakcji.od AND sumaryczna_kwota < zbd_warehouse.wielkosc_transakcji.do;

    RETURN id_przedzialu_wielkosci;
END;
/


-- @WIP TODO

-- Sprzedaż:
CREATE OR REPLACE PROCEDURE fakty_dla_sprzedazy
IS
	kwota_sumaryczna_transakcji number;
	id_obowiazujacej_promocji number;
    id_typu_produktu number;

    id_kategorii number;
    id_dzialu number;
    nazwa_kategorii varchar2(50);
    nazwa_dzialu varchar2(30);
    id_typu_produktu number;
BEGIN
    FOR wiersz IN (SELECT FROM Id_Reklamacji, Id_Oceny, Id_Produktu, Id_Pracownika, Liczba_Produktów, Czas, Zysk, Numer_Transakcji
                   FROM zbd_staging.Sprzedaż) LOOP

		SELECT id INTO id_obowiazujacej_promocji FROM zbd_staging.Promocje
		WHERE wiersz.Czas between od and do;


        SELECT id_kategorii, id_działu INTO id_kategorii, id_dzialu FROM zbd_staging.Produkt WHERE id = wiersz.id_produktu;

        SELECT nazwa INTO nazwa_kategorii FROM zbd_staging.Kategoria_Produktu WHERE id = id_kategorii;
        SELECT nazwa INTO nazwa_dzialu FROM zbd_staging.Dział WHERE id = id_dzialu;

        SELECT id INTO id_typu_produktu FROM zbd_warehouse.typ_produktu
        WHERE kategoria_produktu = nazwa_kategorii AND dzial_produktu = nazwa_dzialu;


        INSERT INTO zbd_warehouse.Fakty_Sprzedaz (Id_Wielkosci_Transakcji, Id_Reklamacji, Id_Promocji, Id_Pracownika,
                                                  Id_Produktu, Id_Typu_Produktu, Id_Lokalizacji, Id_Czasu, Id_Kategorii_Cenowej,
                                                  Id_Oceny, Id_Dostawcy, Zysk, Liczba_Sztuk)
        VALUES (ID_PRZEDZIALU_DLA_DANEJ_SPRZEDAZY(wiersz.Numer_Transakcji), wiersz.Id_Reklamacji, id_obowiazujacej_promocji, 
			    wiersz.Id_Pracownika, wiersz.Id_Produktu, id_typu_produktu, );
    END LOOP;
END;


