-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2017-11-22 18:18:13.832

-- foreign keys
ALTER TABLE Cena_Produktu
    DROP CONSTRAINT CenaProduktu_Produkt;

ALTER TABLE Kategoria_Produktu
    DROP CONSTRAINT Kategoria_Produktu_Dział;

ALTER TABLE Magazyn
    DROP CONSTRAINT Magazyn_Oddział;

ALTER TABLE Magazyn
    DROP CONSTRAINT Magazyn_Produkt;

ALTER TABLE Produkt_Zamówienie
    DROP CONSTRAINT ProduktZamówienie_Produkt;

ALTER TABLE Produkt_Zamówienie
    DROP CONSTRAINT ProduktZamówienie_Zamówienia;

ALTER TABLE Produkt
    DROP CONSTRAINT Produkt_Dział;

ALTER TABLE Produkt
    DROP CONSTRAINT Produkt_KategoriaProduktu;

ALTER TABLE Promocje
    DROP CONSTRAINT Produkt_Promocje;

ALTER TABLE Sprzedaż
    DROP CONSTRAINT Sprzedaż_OcenaOdKlienta;

ALTER TABLE Sprzedaż
    DROP CONSTRAINT Sprzedaż_Pracownik;

ALTER TABLE Sprzedaż
    DROP CONSTRAINT Sprzedaż_Produkt;

ALTER TABLE Sprzedaż
    DROP CONSTRAINT Sprzedaż_Reklamacja;

ALTER TABLE Zamówienia
    DROP CONSTRAINT Zamówienia_Dostawca;

ALTER TABLE Zamówienia
    DROP CONSTRAINT Zamówienia_Oddział;

-- tables
DROP TABLE Cena_Produktu;

DROP TABLE Dostawca;

DROP TABLE Dział;

DROP TABLE Kategoria_Produktu;

DROP TABLE Magazyn;

DROP TABLE Ocena_Od_Klienta;

DROP TABLE Oddział;

DROP TABLE Pracownik;

DROP TABLE Produkt;

DROP TABLE Produkt_Zamówienie;

DROP TABLE Promocje;

DROP TABLE Reklamacja;

DROP TABLE Sprzedaż;

DROP TABLE Zamówienia;

-- End of file.

