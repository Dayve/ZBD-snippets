CREATE OR REPLACE FUNCTION ObliczZysk
    ( id_zakupu_produktu IN NUMBER )
    RETURN NUMBER
IS
    l_sztuk NUMBER;
    id_kupionego_produktu NUMBER;
    id_nadrzednej_transakcji NUMBER;
    timestamp_transakcji timestamp;
    
    aktualna_cena_detaliczna NUMBER;
    aktualna_cena_hurtowa NUMBER;
BEGIN
    SELECT id_produktu, liczba_sztuk, id_transakcji INTO id_kupionego_produktu, l_sztuk, id_nadrzednej_transakcji
    FROM zbd_source.zakup_produktu WHERE id = id_zakupu_produktu;

    SELECT data_i_godzina INTO timestamp_transakcji
    FROM zbd_source.transakcja WHERE id = id_nadrzednej_transakcji;
        
    -- Wygenerowane daty mogą nie obejmować wystarczającego okresu w sposób ciągły:
    BEGIN
        SELECT cena_w_pln INTO aktualna_cena_detaliczna
        FROM zbd_source.obowiazujaca_cena
        WHERE id_produktu = id_kupionego_produktu AND timestamp_transakcji BETWEEN obowiazuje_od AND obowiazuje_do;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            aktualna_cena_detaliczna := 10;  -- advanced software engineering, better back off
    END;
    
    -- Wygenerowane daty mogą nie obejmować wystarczającego okresu w sposób ciągły:
    BEGIN
        SELECT cena_hurtowa_za_sztuke INTO aktualna_cena_hurtowa
        FROM zbd_source.oferta_dostawcy
        WHERE id_produktu = id_kupionego_produktu AND timestamp_transakcji BETWEEN obowiazuje_od AND obowiazuje_do;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            aktualna_cena_hurtowa := 5;  -- advanced software engineering, better back off
    END;

    RETURN l_sztuk * (aktualna_cena_detaliczna - aktualna_cena_hurtowa);
END;
/


-- Oracle PL/SQL nie oferuje niczego co pozwalałoby odwzorować HashMap<String, ArrayList<String>>, robimy więc:
ALTER TABLE spis_kategorii DROP CONSTRAINT kategoria_a_dzial;

DROP TABLE spis_kategorii;
DROP TABLE spis_dzialow;

CREATE TABLE spis_dzialow (
    id NUMBER(12) GENERATED BY DEFAULT ON NULL AS IDENTITY,
    CONSTRAINT nazwa_dzialu_pk PRIMARY KEY (id),
    
    nazwa VARCHAR2(40)
);

CREATE TABLE spis_kategorii (
    id NUMBER(12) GENERATED BY DEFAULT ON NULL AS IDENTITY,
    CONSTRAINT spis_kategorii_pk PRIMARY KEY (id),
    
    nazwa VARCHAR2(40),
    id_odpowiadajacego_dzialu NUMBER(12)
);

ALTER TABLE spis_kategorii ADD CONSTRAINT kategoria_a_dzial
    FOREIGN KEY (id_odpowiadajacego_dzialu)
        REFERENCES spis_dzialow (id) ON DELETE CASCADE;

INSERT INTO spis_dzialow (nazwa) VALUES ('AGD');
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('lodówki', 1);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('suszarki', 1);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('kuchenki gazowe', 1);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('kuchenki mikrofalowe', 1);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('czajniki elektryczne', 1);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('golarki i maszynki elektryczne', 1);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('okapy', 1);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('zmywarki', 1);

INSERT INTO spis_dzialow (nazwa) VALUES ('RTV');
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('telewizory', 2);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('konsole', 2);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('sprzęt audio', 2);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('kable i przejściówki', 2);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('telefony i tablety', 2);

INSERT INTO spis_dzialow (nazwa) VALUES ('artykuły spożywcze');
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('nabiał', 3);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('pieczywo', 3);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('ryby', 3);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('mięso i wędliny', 3);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('mrożonki', 3);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('produkty zbożowe', 3);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('warzywa i owoce', 3);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('słodycze', 3);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('napoje', 3);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('przekąski', 3);

INSERT INTO spis_dzialow (nazwa) VALUES ('alkohole');
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('wina czerwone', 4);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('wina białe', 4);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('whiskey', 4);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('likiery', 4);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('wódki smakowe', 4);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('wódki czyste', 4);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('piwa', 4);

INSERT INTO spis_dzialow (nazwa) VALUES ('kosmetyki');  
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('artykuły do kąpieli', 5);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('kremy', 5);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('higiena jamy ustnej', 5);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('artykuły do makijażu', 5);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('perfumy', 5);

INSERT INTO spis_dzialow (nazwa) VALUES ('zabawki');
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('materiały artystyczne', 6);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('zabawki interaktywne', 6);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('układanki', 6);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('lalki i zabawki pluszowe', 6);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('pojazdy', 6);

INSERT INTO spis_dzialow (nazwa) VALUES ('artykuły papiernicze');
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('szkolne', 7);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('biurowe', 7);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('artystyczne', 7);

INSERT INTO spis_dzialow (nazwa) VALUES ('dom');
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('dekoracje i akcesoria', 8);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('oświetlenie', 8);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('tekstylia', 8);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('szafki, regały, stojaki', 8);

INSERT INTO spis_dzialow (nazwa) VALUES ('ogród');
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('dekoracje ogrodowe', 9);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('grille i akcesoria', 9);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('meble ogrodowe', 9);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('oświetlenie ogrodowe', 9);

INSERT INTO spis_dzialow (nazwa) VALUES ('produkty do sprzątania');
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('pranie i płukanie', 10);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('środki czystości, detergenty', 10);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('środki do samochodu i warsztatu', 10);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('suszenie i prasowanie', 10);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('do podłóg', 10);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('do okien', 10);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('do mebli', 10);

INSERT INTO spis_dzialow (nazwa) VALUES ('multimedia');
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('gry konsolowe', 11);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('gry PC', 11);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('filmy', 11);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('muzyka', 11);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('książki', 11);

INSERT INTO spis_dzialow (nazwa) VALUES ('odzież');
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('odzież sportowa', 12);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('moda damska', 12);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('moda męska', 12);

INSERT INTO spis_dzialow (nazwa) VALUES ('obuwie');
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('dla dzieci', 13);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('sportowe', 13);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('obuwie męskie', 13);
INSERT INTO spis_kategorii (nazwa, id_odpowiadajacego_dzialu) VALUES ('obuwie damskie', 13);

-- Możliwe oceny:
/*INSERT INTO zbd_staging.ocena_od_klienta (ocena)
SELECT DISTINCT to_char(ocena_od_klienta)
FROM zbd_source.transakcja;*/
-- Powyższa instrukcja może nie być odpowiednia - nie każda z ocen mogła zostać przyznana choć raz, lepiej:
INSERT INTO ZBD_STAGING.OCENA_OD_KLIENTA (OCENA) VALUES (to_char('1'));
INSERT INTO ZBD_STAGING.OCENA_OD_KLIENTA (OCENA) VALUES (to_char('2'));
INSERT INTO ZBD_STAGING.OCENA_OD_KLIENTA (OCENA) VALUES (to_char('3'));
INSERT INTO ZBD_STAGING.OCENA_OD_KLIENTA (OCENA) VALUES (to_char('4'));
INSERT INTO ZBD_STAGING.OCENA_OD_KLIENTA (OCENA) VALUES (to_char('5'));


DECLARE
    l_dostawcow NUMBER;
    l_oddzialow NUMBER;
    l_dzialow NUMBER;
    l_kategorii NUMBER;
    l_kasjerow NUMBER;
    l_produktow NUMBER;
    l_reklamacji NUMBER;
    l_ocen NUMBER;
    l_zamowien NUMBER;
BEGIN
    SELECT max(id) INTO l_dostawcow FROM zbd_staging.dostawca;
    SELECT max(id) INTO l_oddzialow FROM zbd_staging.oddział;
    SELECT max(id) INTO l_dzialow FROM zbd_staging.dział;
    SELECT max(id) INTO l_kategorii FROM zbd_staging.kategoria_produktu;
    SELECT max(id) INTO l_kasjerow FROM zbd_staging.pracownik;
    SELECT max(id) INTO l_produktow FROM zbd_staging.produkt;
    SELECT max(id) INTO l_reklamacji FROM zbd_staging.reklamacja;
    SELECT max(id) INTO l_ocen FROM zbd_staging.ocena_od_klienta;
    SELECT max(id) INTO l_zamowien FROM zbd_staging.zamówienia;
    
    IF l_produktow = NULL THEN
        l_produktow := 0;
    END IF;

    -- Dostawcy - samo przepisanie nazw:
    INSERT INTO zbd_staging.dostawca (id, nazwa)
    SELECT id+l_dostawcow, nazwa
    FROM zbd_source.dostawca;
    
    --  Oddzialy - rozdzielenie "miasto, ulica, województwo" na 3 kolumny:
    DECLARE
        l_miejscowosc varchar(50);
        l_ulica_i_numer varchar(50);
        l_wojewodztwo varchar(50);
    BEGIN
        FOR wiersz IN (SELECT id, nazwa as nazwa_z_numerem_oddzialu, adres as pelny_adres from zbd_source.oddzial) LOOP
            -- INSTR znajduje w stringu wystąpienie innego stringa, tutaj z "New York City, Holywood bl, woj. Śląskie" wyciągnie "New York City":
            l_miejscowosc := SUBSTR(wiersz.pelny_adres, 0, INSTR(wiersz.pelny_adres, ', ')-1);
            
            -- Substring od pierwszego (druga jedynka, pierwsza jedynka to indeks w stringu od którego zaczynamy szukać) wystąpienia ', '
            -- o długości (a nie do - ostatni parametr SUBSTR to ilość znaków do wyciągnięcia, czyli tutaj pozycja drugiego ', ' minus pozycja pierwszego ', ':
            l_ulica_i_numer := SUBSTR(wiersz.pelny_adres, INSTR(wiersz.pelny_adres, ', ', 1, 1)+2, INSTR(wiersz.pelny_adres, ', ', 1, 2)-INSTR(wiersz.pelny_adres, ', ', 1, 1)-2);
            
            l_wojewodztwo := SUBSTR(wiersz.pelny_adres, INSTR(wiersz.pelny_adres, ', ', 1, 2)+2, length(wiersz.pelny_adres)-INSTR(wiersz.pelny_adres, ', ', 1, 2)-1);
            
            INSERT INTO zbd_staging.oddział (id, nazwa, miasto, województwo, ulica_i_numer)
            VALUES (wiersz.id+l_oddzialow, wiersz.nazwa_z_numerem_oddzialu, l_miejscowosc, l_wojewodztwo, l_ulica_i_numer);
        END LOOP;
    END;

    -- Działy - samo przepisanie nazw, ale wszystkich i bez powtarzania, inaczej spowoduje to problemy
    -- podczas dopasowania (tabela "dział" generowana skryptem nie będzie użyta, właśnie ze względu na pominięcia i powtórzenia):
    INSERT INTO zbd_staging.dział (id, nazwa)
    SELECT id+l_dzialow, nazwa
    FROM zbd_source.spis_dzialow;
    
    --  Typ/kategoria produktu - powyższe mapowania są konieczne do sensownego przypisania, to informacja której brakuje w tabeli źródłowej
    DECLARE
        id_dzialu NUMBER(12);
    BEGIN
        FOR wiersz IN (SELECT id, nazwa FROM zbd_source.typ_produktu) LOOP
        
        SELECT id_odpowiadajacego_dzialu INTO id_dzialu FROM spis_kategorii
        WHERE nazwa = wiersz.nazwa;
        
        INSERT INTO zbd_staging.kategoria_produktu (id, id_działu, nazwa)
        VALUES (wiersz.id+l_kategorii, id_dzialu, wiersz.nazwa);
        
        END LOOP;
    END;
    
    -- Kasjerzy:
    INSERT INTO zbd_staging.pracownik (id, imię, nazwisko)
    SELECT id+l_kasjerow, imie, nazwisko
    FROM zbd_source.kasjer;
    
    -- Produkty:
    INSERT INTO zbd_staging.produkt (id, id_kategorii, nazwa, id_działu)
    SELECT id+l_produktow, id_typu_produktu, nazwa, id_dzialu
    FROM zbd_source.produkt;
    
    -- Wpisy o stanie magazynu:
    INSERT INTO zbd_staging.magazyn (id_oddziału, id_produktu, liczba_produktów, czas)
    SELECT id_oddzialu, id_produktu, liczba_sztuk, aktualny_na
    FROM zbd_source.obecny_stan_magazynu;
    
    -- Reklamacje:
    INSERT INTO zbd_staging.reklamacja (id, powód)
    SELECT id+l_reklamacji, opis
    FROM zbd_source.reklamacja;
    
    -- Ceny produktu i promocje:
    FOR wiersz IN (SELECT cena_w_pln, czy_jest_promocyjna, obowiazuje_od, obowiazuje_do, id_produktu FROM zbd_source.obowiazujaca_cena) LOOP

        INSERT INTO zbd_staging.cena_produktu (id_produktu, cena, od, do)
        VALUES (wiersz.id_produktu, wiersz.cena_w_pln, wiersz.obowiazuje_od, wiersz.obowiazuje_do);

        IF wiersz.czy_jest_promocyjna > 0 THEN
            INSERT INTO zbd_staging.promocje (id_produktu, obniżka_procentowa, od, do)
            VALUES (wiersz.id_produktu, NULL, wiersz.obowiazuje_od, wiersz.obowiazuje_do);  -- Informacja o obniżce względem ceny niepromocyjnej jest nieobecna
        END IF;

    END LOOP;

    -- Zamówienia:
    DECLARE
        id_dostawcy_zamowienia number;
        cena_hurtowa number;
        id_zamowionego_produktu number;
        id_dopisanego_zamowienia number;
    BEGIN
        FOR wiersz IN (SELECT id, liczba_sztuk, data_realizacji, id_oddzialu, id_oferty FROM zbd_source.zamowienie) LOOP

            SELECT id_dostawcy, cena_hurtowa_za_sztuke, id_produktu
            INTO id_dostawcy_zamowienia, cena_hurtowa, id_zamowionego_produktu
            FROM zbd_source.oferta_dostawcy
            WHERE id = wiersz.id_oferty;

            INSERT INTO zbd_staging.zamówienia (id_oddziału, id_dostawcy, koszt_zamówienia, data_zamówienia)
            VALUES (wiersz.id_oddzialu, id_dostawcy_zamowienia, (cena_hurtowa*wiersz.liczba_sztuk), wiersz.data_realizacji)
            RETURNING zbd_staging.zamówienia.id INTO id_dopisanego_zamowienia;

            INSERT INTO zbd_staging.produkt_zamówienie (id_produktu, id_zamówienia, liczba_sztuk, koszt_zamówienia_sztuki)
            VALUES (id_zamowionego_produktu, id_dopisanego_zamowienia, wiersz.liczba_sztuk, cena_hurtowa);

        END LOOP;
    END;
    
    -- Sprzedaż / transakcja / zakup produktu:
    DECLARE
        id_trans NUMBER(12);
        ocena_trans NUMBER(2);
        suma_trans NUMBER(8,2);
        id_kasj NUMBER(12);
        timestamp_transakcji date;
        id_oceny_o_danej_wart NUMBER(12);
        id_rekl NUMBER(12);
    BEGIN
        FOR wiersz IN (SELECT id, liczba_sztuk, id_produktu, id_transakcji FROM zbd_source.zakup_produktu) LOOP
            
            SELECT     id, sumaryczna_kwota, id_kasjera, ocena_od_klienta,       data_i_godzina 
            INTO id_trans,       suma_trans,    id_kasj,      ocena_trans, timestamp_transakcji
            FROM zbd_source.transakcja
            WHERE id = wiersz.id_transakcji;
            
            BEGIN
                SELECT id INTO id_rekl FROM zbd_source.reklamacja
                WHERE id_zakupu_produktu = wiersz.id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    id_rekl:= NULL;
            END;
            
            SELECT id INTO id_oceny_o_danej_wart FROM zbd_staging.ocena_od_klienta
            WHERE ocena = to_char(ocena_trans);
            
            INSERT INTO zbd_staging.sprzedaż (id_reklamacji, id_oceny, id_produktu, id_pracownika, liczba_produktów, czas, zysk)
            VALUES (id_rekl + l_reklamacji, id_oceny_o_danej_wart + l_ocen, wiersz.id_produktu + l_produktow, id_kasj + l_kasjerow, wiersz.liczba_sztuk, timestamp_transakcji, ObliczZysk(wiersz.id));
            
        END LOOP;
    END;
END;

