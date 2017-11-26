declare
  id_działu number(12);
  id_kategorii number(12);
  id_dostawcy number(12);
  id_oceny number(12);
  id_reklamacji number(12);
  id_pracownika number(12);
  id_oddziału number(12);
  id_zamówienia number(12);
  id_produktu number(12);
  id_promocji number(12);
  id_ceny number(12);
  id_sprzedaży number(12);
  
begin
    SELECT max(id) INTO id_działu FROM zbd_staging.dział;
    SELECT max(id) INTO id_kategorii FROM zbd_staging.kategoria_produktu;
    SELECT max(id) INTO id_dostawcy FROM zbd_staging.dostawca;
    SELECT max(id) INTO id_oceny FROM zbd_staging.ocena_od_klienta;
    SELECT max(id) INTO id_reklamacji FROM zbd_staging.reklamacja;
    SELECT max(id) INTO id_pracownika FROM zbd_staging.pracownik;
    SELECT max(id) INTO id_oddziału FROM zbd_staging.oddział;
    SELECT max(id) INTO id_zamówienia FROM zbd_staging.zamówienia;
    SELECT max(id) INTO id_produktu FROM zbd_staging.produkt;
    SELECT max(id) INTO id_promocji FROM zbd_staging.promocje;
    SELECT max(id) INTO id_ceny FROM zbd_staging.cena_produktu;
    SELECT max(id) INTO id_sprzedaży FROM zbd_staging.sprzedaż;
    

    INSERT INTO zbd_staging.dział (id, nazwa)
    SELECT id + id_działu, nazwa
    FROM zbd_source2.dział;
    
    INSERT INTO zbd_staging.kategoria_produktu (id, id_działu, nazwa)
    SELECT id + id_kategorii, id_działu, nazwa
    FROM zbd_source2.kategoria_produktu;
    
    INSERT INTO zbd_staging.dostawca (id, nazwa)
    SELECT id + id_dostawcy, nazwa
    FROM zbd_source2.dostawca;
    
    INSERT INTO zbd_staging.ocena_od_klienta (id, ocena)
    SELECT id + id_oceny, ocena
    FROM zbd_source2.ocena_od_klienta;
    
    INSERT INTO zbd_staging.reklamacja (id, powód)
    SELECT id + id_reklamacji, powód
    FROM zbd_source2.reklamacja;
    
    INSERT INTO zbd_staging.pracownik (id, imię, nazwisko)
    SELECT id + id_pracownika, imię, nazwisko
    FROM zbd_source2.pracownik;
    
    INSERT INTO zbd_staging.oddział (id, nazwa, miasto, województwo, ulica_i_numer)
    SELECT id + id_oddziału, nazwa, miasto, województwo, ulica_i_numer
    FROM zbd_source2.oddział;
    
    INSERT INTO zbd_staging.zamówienia (id, id_oddziału, id_dostawcy, koszt_zamówienia, data_zamówienia)
    SELECT id + id_zamówienia, id_oddziału, id_dostawcy, koszt_zamówienia, data_zamówienia
    FROM zbd_source2.zamówienia;
    
    INSERT INTO zbd_staging.produkt (id, id_kategorii, id_działu, nazwa)
    SELECT id + id_produktu, id_kategorii, id_działu, nazwa
    FROM zbd_source2.produkt;
        
    INSERT INTO zbd_staging.promocje (id, id_produktu, obniżka_procentowa, od, do)
    SELECT id + id_promocji, id_produktu, obniżka_procentowa, od, do
    FROM zbd_source2.promocje;
            
    INSERT INTO zbd_staging.cena_produktu (id, id_produktu, cena, od, do)
    SELECT id + id_ceny, id_produktu, cena, od, do
    FROM zbd_source2.cena_produktu;
                
    INSERT INTO zbd_staging.produkt_zamówienie (id_produktu, id_zamówienia, liczba_sztuk, koszt_zamówienia_sztuki)
    SELECT id_produktu, id_zamówienia, liczba_sztuk, koszt_zamówienia_sztuki
    FROM zbd_source2.produkt_zamówienie;
                                
    INSERT INTO zbd_staging.magazyn (id_oddziału, id_produktu, liczba_produktów, czas)
    SELECT id_oddziału, id_produktu, liczba_produktów, czas
    FROM zbd_source2.magazyn;
	
    INSERT INTO zbd_staging.sprzedaż (id, id_reklamacji, id_oceny, id_produktu, id_pracownika, id_oddziału, liczba_produktów, czas, zysk, numer_transakcji)
    SELECT id + id_sprzedaży, id_reklamacji, id_oceny, id_produktu, id_pracownika, id_oddziału, liczba_produktów, czas, zysk, numer_transakcji
    FROM zbd_source2.sprzedaż;
end;