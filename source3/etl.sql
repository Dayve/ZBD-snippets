DECLARE l_dostawcow NUMBER :=0;
l_oddzialow NUMBER :=0;
l_dzialow NUMBER :=0;
l_kategorii NUMBER :=0;
l_pracownikow NUMBER :=0;
l_produktow NUMBER :=0;
l_reklamacji NUMBER :=0;
l_ocen NUMBER :=0;
l_zamowien NUMBER :=0;
BEGIN
SELECT max(id) INTO l_dostawcow
FROM staging.dostawca;

SELECT max(id) INTO l_oddzialow
FROM staging.oddział;

SELECT max(id) INTO l_dzialow
FROM staging.dział;

SELECT max(id) INTO l_kategorii
FROM staging.kategoria_produktu;

SELECT max(id) INTO l_pracownikow
FROM staging.pracownik;

SELECT max(id) INTO l_produktow
FROM staging.produkt;

SELECT max(id) INTO l_reklamacji
FROM staging.reklamacja;

SELECT max(id) INTO l_ocen
FROM staging.ocena_od_klienta;

SELECT max(id) INTO l_zamowien
FROM staging.zamówienia;
-- dostawcy

INSERT INTO staging.dostawca (nazwa)
SELECT nazwa
FROM dostawca;

-- pracownicy

INSERT INTO STAGING.pracownik (imię, nazwisko)
SELECT imie,
       nazwisko
FROM pracownik;

-- reklamacje

INSERT INTO STAGING.reklamacja ("POWÓD")
SELECT powod
FROM reklamacja;

-- ocena

INSERT INTO STAGING.ocena_od_klienta (ocena)
SELECT tresc
FROM ocenaklienta;

--oddzial

INSERT INTO STAGING."ODDZIAŁ" (nazwa,
                               miasto,
                               "WOJEWÓDZTWO",
                               ulica_i_numer)
SELECT nazwa,
       miasto,
       wojewodztwo,
       'Brak danych' AS d
FROM oddzial;

DECLARE new_product_id number(12);
id_dzialu number(12);
li_dzialow number(12);
li_kategorii number(12);
id_kategorii number(12);
nazwa_dzialu varchar(50);
last_product_id varchar(50);
nazwa_kategorii varchar(50);
nazwa_produktu varchar(50);

BEGIN
FOR one_row IN
  (SELECT id AS last_id,
          nazwaproduktu AS nazwa_produktu,
          nazwadzialu AS nazwa_dzialu,
          nazwatypu AS nazwa_typu
   FROM produkt) LOOP
      SELECT count(*) INTO li_dzialow
      FROM STAGING."DZIAŁ"
      WHERE STAGING."DZIAŁ".nazwa = one_row.nazwa_dzialu;

      IF li_dzialow >= 1 THEN
      SELECT id INTO id_dzialu
      FROM STAGING."DZIAŁ"
      WHERE nazwa = one_row.nazwa_dzialu
        AND ROWNUM = 1;

      ELSE
      INSERT INTO STAGING."DZIAŁ" (nazwa)
      VALUES(one_row.nazwa_dzialu) RETURNING STAGING."DZIAŁ".id INTO id_dzialu;

      END IF;

      SELECT count(*) INTO li_kategorii
      FROM STAGING.kategoria_produktu
      WHERE STAGING.kategoria_produktu.nazwa = one_row.nazwa_typu
        AND STAGING.kategoria_produktu."ID_DZIAŁU" = id_dzialu ;

      IF li_kategorii >= 1 THEN
      SELECT id INTO id_kategorii
      FROM STAGING.kategoria_produktu
      WHERE nazwa = one_row.nazwa_typu
        AND ROWNUM = 1;

      ELSE
      INSERT INTO STAGING.kategoria_produktu (nazwa, "ID_DZIAŁU")
      VALUES(one_row.nazwa_typu,
             id_dzialu) RETURNING STAGING.kategoria_produktu.id INTO id_kategorii;
      END IF;

      INSERT INTO STAGING.produkt (nazwa, "ID_DZIAŁU", id_kategorii)
      VALUES(one_row.nazwa_produktu,
             id_dzialu,
             id_kategorii);
    END LOOP;
END;

IF l_produktow IS NULL THEN l_produktow := 0;

END IF;

--promocje

INSERT INTO STAGING.promocje (id_produktu, "OBNIŻKA_PROCENTOWA", od, DO)
SELECT promocja.produkt_id+l_produktow,
       promocja.wartoscprocentowa,
       promocja.datastartu,
       promocja.datakonca
FROM promocja;

-- ceny

INSERT INTO STAGING.cena_produktu (id_produktu, cena, od, DO)
SELECT cena.produkt_id+l_produktow,
       cena.wartosc,
       cena.datastartu,
       cena.datakonca
FROM cena;

-- magazyn

INSERT INTO STAGING.MAGAZYN (id_oddziału, id_produktu, liczba_produktów, czas)
SELECT oddzial_id,
       produkt_id,
       liczbasztuk,
       DATA
FROM STANMAGAZYNU;

-- zamowienia

INSERT INTO STAGING."ZAMÓWIENIA" (id_oddziału,
                                  id_dostawcy,
                                  koszt_zamówienia,
                                  "DATA_ZAMÓWIENIA")
SELECT oddzial_id,
       dostawca_id,
       koszt,
       DATA
FROM zamowienie;

--sprzedaz
 IF l_pracownikow IS NULL THEN l_pracownikow := 0;

END IF;

BEGIN
FOR one_row IN
  (SELECT liczbasztuk,
          zysk,
          DATA,
          produkt_id,
          ocenaklienta_id,
          pracownik_id,
          reklamacja_id,
          numer
   FROM sprzedaz) LOOP

    INSERT INTO STAGING."SPRZEDAŻ" (id_reklamacji,
                                    id_oceny,
                                    id_produktu,
                                    id_pracownika,
                                    liczba_produktów,
                                    czas,
                                    zysk,
                                    numer_transakcji)
    VALUES(one_row.reklamacja_id+l_reklamacji,
           one_row.ocenaklienta_id+l_ocen,
           one_row.produkt_id+l_produktow,
           one_row.pracownik_id+l_pracownikow,
           one_row.liczbasztuk,
           one_row.data,
           one_row.zysk,
           one_row.numer);

  END LOOP;
END;

-- zamowienie produkt
 IF l_zamowien IS NULL THEN l_zamowien := 0;
END IF;

DECLARE liczba_sztuk number(12);
BEGIN
FOR one_row IN
  (SELECT cenahurtowa,
          zamowienie_id,
          produkt_id
   FROM zamowienieprodukt) LOOP
      SELECT liczbasztuk INTO liczba_sztuk
      FROM zamowienie
      WHERE id = one_row.zamowienie_id;

      INSERT INTO STAGING."PRODUKT_ZAMÓWIENIE" (id_produktu,
                                                id_zamówienia,
                                                liczba_sztuk,
                                                koszt_zamówienia_sztuki)
      VALUES(one_row.produkt_id+l_produktow,
             one_row.zamowienie_id+l_zamowien,
             liczba_sztuk,
             one_row.cenahurtowa);
    END LOOP;
END;
END;
