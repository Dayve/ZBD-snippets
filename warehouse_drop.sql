-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2017-11-25 18:24:48.354

-- foreign keys
ALTER TABLE Fakty_Magazyn
    DROP CONSTRAINT Czas_Magazyn;

ALTER TABLE Fakty_Zamowienia
    DROP CONSTRAINT Czas_Zamowienia;

ALTER TABLE Fakty_Sprzedaz
    DROP CONSTRAINT Dostawca_Sprzedaz;

ALTER TABLE Fakty_Zamowienia
    DROP CONSTRAINT Dostawca_Zamowienia;

ALTER TABLE Fakty_Magazyn
    DROP CONSTRAINT Fakty_Magazyn_Dzial;

ALTER TABLE Fakty_Sprzedaz
    DROP CONSTRAINT Fakty_Sprzedaz_Czas;

ALTER TABLE Fakty_Sprzedaz
    DROP CONSTRAINT Fakty_Sprzedaz_Dzial;

ALTER TABLE Fakty_Zamowienia
    DROP CONSTRAINT Fakty_Zamowienia_Dzial;

ALTER TABLE Fakty_Magazyn
    DROP CONSTRAINT Lokalizacja_Magazyn;

ALTER TABLE Fakty_Zamowienia
    DROP CONSTRAINT Lokalizacja_Zamowienia;

ALTER TABLE Fakty_Magazyn
    DROP CONSTRAINT Produkt_Magazyn;

ALTER TABLE Fakty_Zamowienia
    DROP CONSTRAINT PrzedKosztuZam_Zam;

ALTER TABLE Fakty_Sprzedaz
    DROP CONSTRAINT Sprzedaz_KategoriaCenowa;

ALTER TABLE Fakty_Sprzedaz
    DROP CONSTRAINT Sprzedaz_Lokalizacja;

ALTER TABLE Fakty_Sprzedaz
    DROP CONSTRAINT Sprzedaz_OcenaOdKlienta;

ALTER TABLE Fakty_Sprzedaz
    DROP CONSTRAINT Sprzedaz_Pracownik;

ALTER TABLE Fakty_Sprzedaz
    DROP CONSTRAINT Sprzedaz_Produkt;

ALTER TABLE Fakty_Sprzedaz
    DROP CONSTRAINT Sprzedaz_Promocja;

ALTER TABLE Fakty_Sprzedaz
    DROP CONSTRAINT Sprzedaz_Reklamacja;

ALTER TABLE Fakty_Sprzedaz
    DROP CONSTRAINT Sprzedaz_WielkoscTransakcji;

ALTER TABLE Fakty_Zamowienia
    DROP CONSTRAINT Zamowienia_Produkt;

-- tables
DROP TABLE Czas;

DROP TABLE Dostawca;

DROP TABLE Fakty_Magazyn;

DROP TABLE Fakty_Sprzedaz;

DROP TABLE Fakty_Zamowienia;

DROP TABLE Kategoria_Cenowa;

DROP TABLE Lokalizacja;

DROP TABLE Ocena_Od_Klienta;

DROP TABLE Pracownik;

DROP TABLE Produkt;

DROP TABLE Promocja;

DROP TABLE Przedzial_Kosztu_Zamowienia;

DROP TABLE Reklamacja;

DROP TABLE Typ_Produktu;

DROP TABLE Wielkosc_Transakcji;

-- End of file.

