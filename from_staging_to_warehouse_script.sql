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


CREATE OR REPLACE FUNCTION ID_PRZEDZIALU_CENY
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
    WHERE sumaryczna_kwota >= zbd_warehouse.wielkosc_transakcji.od_PLN AND sumaryczna_kwota < zbd_warehouse.wielkosc_transakcji.do_PLN;

    RETURN id_przedzialu_wielkosci;
END;
/

CREATE OR REPLACE FUNCTION CENA_PRODUKTU_W_TRANSAKCJI
    (dany_numer_transakcji IN NUMBER)
    RETURN NUMBER
IS
    cena_produktu NUMBER;
BEGIN
    SELECT zbd_staging.cena_produktu.cena INTO cena_produktu
    FROM zbd_staging.cena_produktu
    LEFT JOIN zbd_staging.Sprzedaż
    ON zbd_staging.cena_produktu.id_produktu = zbd_staging.Sprzedaż.id_produktu
    WHERE zbd_staging.Sprzedaż.czas BETWEEN zbd_staging.cena_produktu.od AND zbd_staging.cena_produktu.do
    AND zbd_staging.Sprzedaż.numer_transakcji = dany_numer_transakcji;
    
    RETURN cena_produktu;
END;
/

CREATE OR REPLACE FUNCTION ID_KATEGORII_CENOWEJ
    (dany_numer_transakcji IN NUMBER)
    RETURN NUMBER
IS
    cena_produktu NUMBER;
    id_kategorii_cenowej NUMBER;
BEGIN
    cena_produktu := CENA_PRODUKTU_W_TRANSAKCJI(dany_numer_transakcji);

    SELECT id INTO id_kategorii_cenowej FROM zbd_warehouse.kategoria_cenowa
    WHERE cena_produktu >= zbd_warehouse.kategoria_cenowa.od_PLN AND cena_produktu < zbd_warehouse.kategoria_cenowa.do_PLN;

    RETURN id_kategorii_cenowej;
END;
/

CREATE OR REPLACE FUNCTION ID_KOSZTU_ZAMOWIENIA
    (koszt_zamowienia IN NUMBER)
    RETURN NUMBER
IS
    przedzial_kosztu_zamowienia NUMBER;
BEGIN

    SELECT id INTO przedzial_kosztu_zamowienia FROM zbd_warehouse.przedzial_kosztu_zamowienia
    WHERE koszt_zamowienia >= zbd_warehouse.przedzial_kosztu_zamowienia.od_PLN AND koszt_zamowienia < zbd_warehouse.przedzial_kosztu_zamowienia.do_PLN;

    RETURN przedzial_kosztu_zamowienia;
END;
/

CREATE OR REPLACE FUNCTION DOSTAWCA_DANEGO_PRODUKTU
    (p_id_produktu IN NUMBER)
    RETURN NUMBER
IS
    id_zamowienia_produktu NUMBER;
    id_dostawcy_produktu NUMBER;
BEGIN
    SELECT Id_Zamówienia INTO id_zamowienia_produktu FROM Produkt_Zamówienie
    WHERE Id_Produktu = p_id_produktu;

    SELECT Id_Dostawcy INTO id_dostawcy_produktu FROM Zamówienia
    WHERE Id = id_zamowienia_produktu;

    RETURN id_dostawcy_produktu;
END;
/

create or replace FUNCTION ZYSK_ZE_SPRZEDAZY
    (p_id_Produktu IN NUMBER,
     p_liczba_produktów IN NUMBER,
     p_numer_transakcji IN NUMBER,
     p_Id_Oddzialu IN NUMBER)
    RETURN NUMBER
IS
    Liczba_Produktow_Zamowienia NUMBER;
    Szukany_Koszt_Sztuki NUMBER;
    Obecna_Liczba_Produktow NUMBER;
BEGIN
    SELECT Liczba_Produktów 
    INTO Obecna_Liczba_Produktow
    FROM zbd_staging.MAGAZYN
    WHERE Id_Produktu = p_Id_Produktu
    AND Id_Oddziału = p_Id_Oddzialu
    AND rownum = 1
    ORDER BY czas DESC;

    FOR wiersz IN (SELECT Id FROM zbd_staging.Zamówienia WHERE Id_Oddziału = p_Id_Oddzialu ORDER BY Data_Zamówienia DESC) LOOP
        SELECT Liczba_Sztuk, Koszt_Zamówienia_Sztuki INTO Liczba_Produktow_Zamowienia,
        Szukany_Koszt_Sztuki FROM Produkt_Zamówienie WHERE Id_Zamówienia = wiersz.Id;

        Obecna_Liczba_Produktow := Obecna_Liczba_Produktow - Liczba_Produktow_Zamowienia;

        EXIT WHEN Obecna_Liczba_Produktow <= 0;
    END LOOP;

    return (CENA_PRODUKTU_W_TRANSAKCJI(p_numer_transakcji) - Szukany_Koszt_Sztuki) * p_liczba_produktów;
END;
/

-- Sprzedaż:
create or replace PROCEDURE fakty_dla_sprzedazy
IS
    kwota_sumaryczna_transakcji number;
    id_obowiazujacej_promocji number;
    id_typu_produktu number;

    id_kategorii number;
    id_dzialu number;
    nazwa_kategorii varchar2(50);
    nazwa_dzialu varchar2(30);
    id_nowego_czasu number;

BEGIN
    FOR wiersz IN (SELECT Id_Reklamacji, Id_Oceny, Id_Produktu, Id_Pracownika, Liczba_Produktów, Czas, Zysk, Numer_Transakcji, Id_Oddziału
                   FROM zbd_staging.Sprzedaż) LOOP

        SELECT id INTO id_obowiazujacej_promocji FROM zbd_staging.Promocje
        WHERE wiersz.Czas between od and do;


        SELECT id_kategorii, id_działu INTO id_kategorii, id_dzialu FROM zbd_staging.Produkt WHERE id = wiersz.id_produktu;

        SELECT nazwa INTO nazwa_kategorii FROM zbd_staging.Kategoria_Produktu WHERE id = id_kategorii;
        SELECT nazwa INTO nazwa_dzialu FROM zbd_staging.Dział WHERE id = id_dzialu;

        SELECT id INTO id_typu_produktu FROM zbd_warehouse.typ_produktu
        WHERE kategoria_produktu = nazwa_kategorii AND dzial_produktu = nazwa_dzialu;


        id_nowego_czasu := DODAJ_CZAS(wiersz.Czas);

        INSERT INTO zbd_warehouse.Fakty_Sprzedaz 
        (Id_Wielkosci_Transakcji, Id_Reklamacji, Id_Promocji, Id_Pracownika,
          Id_Produktu, Id_Typu_Produktu, Id_Lokalizacji, Id_Czasu, Id_Kategorii_Cenowej,
          Id_Oceny, Id_Dostawcy, Zysk, Liczba_Sztuk)
        VALUES 
        (ID_PRZEDZIALU_CENY(wiersz.Numer_Transakcji), wiersz.Id_Reklamacji, id_obowiazujacej_promocji, 
        wiersz.Id_Pracownika, wiersz.Id_Produktu, id_typu_produktu, wiersz.Id_Oddziału, id_nowego_czasu, 
        ID_KATEGORII_CENOWEJ(wiersz.Numer_Transakcji), wiersz.Id_Oceny, DOSTAWCA_DANEGO_PRODUKTU(wiersz.Id_Produktu),
        ZYSK_ZE_SPRZEDAZY(wiersz.Id_Produktu, wiersz.Liczba_Produktów, wiersz.Numer_Transakcji, wiersz.Id_Oddziału), wiersz.Liczba_Produktów);
    END LOOP;
END;

/-- Zamówienia: TODO
create or replace PROCEDURE fakty_dla_zamowien
IS
	id_typu_produktu number;
	id_kategorii number;
	id_dzialu number;
	nazwa_kategorii varchar2(50);
	nazwa_dzialu varchar2(30);
	
BEGIN
	FOR wiersz IN (SELECT Id_Oddziału, Id_Dostawcy, Koszt_Zamówienia, Data_Zamówienia, Liczba_Sztuk, Id_Produktu
	FROM zbd_staging.Zamówienia JOIN zbd_staging.Produkt_Zamówienie ON zbd_staging.Zamówienia.Id = zbd_staging.Produkt_Zamówienie.Id_Zamówienia) LOOP
	
		SELECT id_kategorii, id_działu INTO id_kategorii, id_dzialu FROM zbd_staging.Produkt WHERE id = wiersz.Id_Produktu;

        SELECT nazwa INTO nazwa_kategorii FROM zbd_staging.Kategoria_Produktu WHERE id = id_kategorii;
        SELECT nazwa INTO nazwa_dzialu FROM zbd_staging.Dział WHERE id = id_dzialu;

        SELECT id INTO id_typu_produktu FROM zbd_warehouse.typ_produktu
        WHERE kategoria_produktu = nazwa_kategorii AND dzial_produktu = nazwa_dzialu;

		INSERT INTO zbd_warehouse.Fakty_Zamowienia (Id_Lokalizacji, Id_Przedzialu_Kosztu, Id_Produktu, Id_Typu_Produktu, Id_Czasu, Id_Dostawcy, Liczba_Sztuk)
		VALUES (wiersz.Id_Oddziału, ID_KOSZTU_ZAMOWIENIA(wiersz.Koszt_Zamówienia), wiersz.Id_Produktu, id_typu_produktu, DODAJ_CZAS(wiersz.Data_Zamówienia), wiersz.Id_Dostawcy, wiersz.Liczba_Sztuk);
		
	END LOOP;
END;
/
