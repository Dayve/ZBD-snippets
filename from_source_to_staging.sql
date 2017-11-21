-- Jeśli po wykonaniu jakichś instrukcji insertowania danych nie widać zmian to jeszcze commit trzeba nakliknąć

-- Dostawcy - samo przepisanie nazw:
INSERT INTO zbd_staging.dostawca (nazwa)
SELECT zbd_source.dostawca.nazwa
FROM zbd_source.dostawca;


--INSERT INTO zbd_staging.oddział (nazwa, substr(miejscowosc_przecinek_spacja, 1, length(miejscowosc_przecinek_spacja)-2), 'woj', 'ul num')
--SELECT nazwa, regexp_substr(adres, '(\w+),\s', 1, 1) as miejscowosc_przecinek_spacja, nazwa, nazwa
--FROM zbd_source.oddzial;
--select adres, substr(adres, 1, length(adres)-2) from zbd_source.oddzial;
--select 'ab, cd, ef', INSTR('ab, cd, ef', ', ', 1, 1) as pierwsze, INSTR('ab, cd, ef', ', ', 1, 2) as drugie from zbd_source.oddzial;
--select adres, SUBSTR(adres, INSTR(adres, ', ', 1, 2)+2, length(adres)-INSTR(adres, ', ', 1, 2)-1) as wynik from zbd_source.oddzial;

--  Oddziały - rozdzielenie "miasto, ulica, województwo" na 3 kolumny:
declare
  l_miejscowosc varchar(50);
  l_ulica_i_numer varchar(50);
  l_wojewodztwo varchar(50);
begin
  for wiersz in (select nazwa as nazwa_z_numerem_oddzialu, adres as pelny_adres from zbd_source.oddzial) loop
    -- INSTR znajduje w stringu wystąpienie innego stringa, tutaj z "New York City, Holywood bl, woj. Śląskie" wyciągnie "New York City"
    l_miejscowosc := SUBSTR(wiersz.pelny_adres, 0, INSTR(wiersz.pelny_adres, ', ')-1);
    
    -- Substring od pierwszego (druga jedynka, pierwsza jedynka to indeks w stringu od którego zaczynamy szukać) wystąpienia ', '
    -- o długości (a nie: do, bo drugi ostatni parametr SUBSTR to ilość znaków do wyciągnięcia, czyli pozycja drugiego ', ' minus pozycja pierwszego ', '
    l_ulica_i_numer := SUBSTR(wiersz.pelny_adres, INSTR(wiersz.pelny_adres, ', ', 1, 1)+2, INSTR(wiersz.pelny_adres, ', ', 1, 2)-INSTR(wiersz.pelny_adres, ', ', 1, 1)-2);
    
    l_wojewodztwo := SUBSTR(wiersz.pelny_adres, INSTR(wiersz.pelny_adres, ', ', 1, 2)+2, length(wiersz.pelny_adres)-INSTR(wiersz.pelny_adres, ', ', 1, 2)-1);
    
    dbms_output.put_line(l_miejscowosc || '    ' || l_ulica_i_numer || '    ' || l_wojewodztwo);
    
    INSERT INTO zbd_staging.oddział (nazwa, miasto, województwo, ulica_i_numer)
    VALUES (wiersz.nazwa_z_numerem_oddzialu, l_miejscowosc, l_wojewodztwo, l_ulica_i_numer);
    
  end loop;
end;
    
    
    