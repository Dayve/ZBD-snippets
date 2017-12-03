CREATE MATERIALIZED VIEW top_types_over_last_year
    BUILD DEFERRED   -- wypelnij widok przy najblizszej operacji odswiezenia
    REFRESH COMPLETE -- wykonuj odswiezanie pelne, wykonujac zapytanie (nie ma tutaj możliwości FAST REFRESH ze wzgledu na zapytanie zlozone) 
AS
SELECT SUM(zbd_warehouse.fakty_sprzedaz.liczba_sztuk) AS Ilosc_sumaryczna,
       DECODE(GROUPING(id_lokalizacji),
              1,
              '[Podsumowanie dla typu]',
              (SELECT oddzial FROM lokalizacja WHERE id = id_lokalizacji))
       AS Oddzial,
       DECODE(GROUPING(id_typu_produktu),
              1,
              '[Podsumowanie całościowe]',
              (SELECT dzial_produktu || ', ' || kategoria_produktu FROM typ_produktu WHERE id = id_typu_produktu))
       AS Typ
FROM zbd_warehouse.fakty_sprzedaz
WHERE EXISTS
   (SELECT * FROM zbd_warehouse.czas
    WHERE zbd_warehouse.fakty_sprzedaz.id_czasu = zbd_warehouse.czas.id
    AND zbd_warehouse.czas.data between sysdate and add_months(trunc(sysdate), -12))
GROUP BY ROLLUP (id_typu_produktu, id_lokalizacji);

DROP MATERIALIZED VIEW top_types_over_last_year;


CREATE MATERIALIZED VIEW top_suppliers
    BUILD DEFERRED
    REFRESH COMPLETE
AS
SELECT
    id_dostawcy,
    sum(zysk) AS Zysk_na_sprzedaży,
    count(id_reklamacji) AS Ilość_reklamacji FROM fakty_sprzedaz
GROUP BY id_dostawcy
ORDER BY Zysk_na_sprzedaży DESC, Ilość_reklamacji ASC;

DROP MATERIALIZED VIEW top_suppliers;

