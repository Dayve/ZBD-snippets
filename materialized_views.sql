CREATE MATERIALIZED VIEW zysk_za_ostatni_rok AS
select sum(zysk) from zbd_warehouse.fakty_sprzedaz
WHERE zbd_warehouse.fakty_sprzedaz.id_lokalizacji = 1
    AND EXISTS
   (SELECT * FROM zbd_warehouse.czas
    WHERE zbd_warehouse.fakty_sprzedaz.id_czasu = zbd_warehouse.czas.id
    AND zbd_warehouse.czas.data between sysdate and add_months(trunc(sysdate), -12));


--CREATE MATERIALIZED VIEW top_product_types AS
SELECT SUM(zbd_warehouse.fakty_sprzedaz.liczba_sztuk),
       zbd_warehouse.fakty_sprzedaz.id_typu_produktu,
       (SELECT zbd_warehouse.lokalizacja.oddzial  FROM zbd_warehouse.lokalizacja WHERE id = id_lokalizacji)
FROM zbd_warehouse.fakty_sprzedaz
WHERE EXISTS
   (SELECT * FROM zbd_warehouse.czas
    WHERE zbd_warehouse.fakty_sprzedaz.id_czasu = zbd_warehouse.czas.id
    AND zbd_warehouse.czas.data between sysdate and add_months(trunc(sysdate), -12))
GROUP BY ROLLUP (zbd_warehouse.fakty_sprzedaz.id_typu_produktu, 
                 zbd_warehouse.fakty_sprzedaz.id_lokalizacji);


DROP MATERIALIZED VIEW zysk_za_ostatni_rok;