-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2017-11-12 20:48:06.319

-- tables
-- Table: Czas
CREATE TABLE Czas (
    IdCzasu integer  NOT NULL,
    Data date  NOT NULL,
    Godzina integer  NOT NULL,
    DzienTygodnia varchar2(50)  NOT NULL,
    Miesiac varchar2(50)  NOT NULL,
    Kwartal integer  NOT NULL,
    Rok integer  NOT NULL,
    CONSTRAINT Czas_pk PRIMARY KEY (IdCzasu)
) ;

-- Table: Dostawca
CREATE TABLE Dostawca (
    IdDostawcy integer  NOT NULL,
    Nazwa varchar2(50)  NOT NULL,
    CONSTRAINT Dostawca_pk PRIMARY KEY (IdDostawcy)
) ;

-- Table: Fakty_Magazyn
CREATE TABLE Fakty_Magazyn (
    IdProduktu integer  NOT NULL,
    IdLokalizacji integer  NOT NULL,
    IdCzasu integer  NOT NULL,
    LiczbaSztuk integer  NOT NULL
) ;

-- Table: Fakty_Sprzedaz
CREATE TABLE Fakty_Sprzedaz (
    IdWielkosciTransakcji integer  NOT NULL,
    IdReklamacji integer  NOT NULL,
    IdPromocji integer  NOT NULL,
    IdPracownika integer  NOT NULL,
    IdProduktu integer  NOT NULL,
    IdLokalizacji integer  NOT NULL,
    IdCzasu integer  NOT NULL,
    IdKategoriiCenowej integer  NOT NULL,
    IdOceny integer  NOT NULL,
    IdDostawcy integer  NOT NULL,
    Zysk number(5,2)  NOT NULL,
    LiczbaSztuk integer  NOT NULL
) ;

-- Table: Fakty_Zamowienia
CREATE TABLE Fakty_Zamowienia (
    IdLokalizacji integer  NOT NULL,
    IdPrzedzialuKosztuZamowienia integer  NOT NULL,
    IdProduktu integer  NOT NULL,
    IdCzasu integer  NOT NULL,
    IdDostawcy integer  NOT NULL,
    LiczbaSztuk integer  NOT NULL
) ;

-- Table: KategoriaCenowa
CREATE TABLE KategoriaCenowa (
    IdKategoriiCenowej  integer  NOT NULL,
    PrzedzialCenowy varchar2(20)  NOT NULL,
    CONSTRAINT KategoriaCenowa_pk PRIMARY KEY (IdKategoriiCenowej )
) ;

-- Table: Lokalizacja
CREATE TABLE Lokalizacja (
    IdLokalizacji integer  NOT NULL,
    Wojewodztwo varchar2(50)  NOT NULL,
    Miasto varchar2(50)  NOT NULL,
    Oddzial varchar2(50)  NOT NULL,
    CONSTRAINT Lokalizacja_pk PRIMARY KEY (IdLokalizacji)
) ;

-- Table: Ocena_Od_Klienta
CREATE TABLE Ocena_Od_Klienta (
    IdOceny integer  NOT NULL,
    Ocena varchar2(30)  NOT NULL,
    CONSTRAINT Ocena_Od_Klienta_pk PRIMARY KEY (IdOceny)
) ;

-- Table: Pracownik
CREATE TABLE Pracownik (
    IdPracownika number(5)  NOT NULL,
    Imię varchar2(50)  NOT NULL,
    Nazwisko varchar2(50)  NOT NULL,
    CONSTRAINT Pracownik_pk PRIMARY KEY (IdPracownika)
) ;

-- Table: Produkt
CREATE TABLE Produkt (
    IdProduktu integer  NOT NULL,
    NazwaTypu varchar2(50)  NOT NULL,
    NazwaProduktu varchar2(50)  NOT NULL,
    CONSTRAINT Produkt_pk PRIMARY KEY (IdProduktu)
) ;

-- Table: Promocja
CREATE TABLE Promocja (
    IdPromocji integer  NOT NULL,
    PrzedzialProcentowyObnizki smallint  NOT NULL,
    CONSTRAINT Promocja_pk PRIMARY KEY (IdPromocji)
) ;

-- Table: PrzedzialKosztuZamowienia
CREATE TABLE PrzedzialKosztuZamowienia (
    IdPrzedzialuKosztuZamowienia integer  NOT NULL,
    PrzedzialKosztuZamowienia varchar2(20)  NOT NULL,
    CONSTRAINT PrzedzialKosztuZamowienia_pk PRIMARY KEY (IdPrzedzialuKosztuZamowienia)
) ;

-- Table: Reklamacja
CREATE TABLE Reklamacja (
    IdReklamacji integer  NOT NULL,
    Powód varchar2(255)  NOT NULL,
    CONSTRAINT Reklamacja_pk PRIMARY KEY (IdReklamacji)
) ;

-- Table: WielkoscTransakcji
CREATE TABLE WielkoscTransakcji (
    IdWielkosciTransakcji integer  NOT NULL,
    PrzedzialKwotySumaryczne varchar2(50)  NOT NULL,
    CONSTRAINT WielkoscTransakcji_pk PRIMARY KEY (IdWielkosciTransakcji)
) ;

-- foreign keys
-- Reference: Czas_Magazyn (table: Fakty_Magazyn)
ALTER TABLE Fakty_Magazyn ADD CONSTRAINT Czas_Magazyn
    FOREIGN KEY (IdCzasu)
    REFERENCES Czas (IdCzasu);

-- Reference: Czas_Zamówienia (table: Fakty_Zamowienia)
ALTER TABLE Fakty_Zamowienia ADD CONSTRAINT Czas_Zamówienia
    FOREIGN KEY (IdCzasu)
    REFERENCES Czas (IdCzasu);

-- Reference: Dostawca_Sprzedaż (fakty) (table: Fakty_Sprzedaz)
ALTER TABLE Fakty_Sprzedaz ADD CONSTRAINT Dostawca_Sprzedaz
    FOREIGN KEY (IdDostawcy)
    REFERENCES Dostawca (IdDostawcy);

-- Reference: Dostawca_Zamówienia (table: Fakty_Zamowienia)
ALTER TABLE Fakty_Zamowienia ADD CONSTRAINT Dostawca_Zamówienia
    FOREIGN KEY (IdDostawcy)
    REFERENCES Dostawca (IdDostawcy);

-- Reference: Lokalizacja_Magazyn (table: Fakty_Magazyn)
ALTER TABLE Fakty_Magazyn ADD CONSTRAINT Lokalizacja_Magazyn
    FOREIGN KEY (IdLokalizacji)
    REFERENCES Lokalizacja (IdLokalizacji);

-- Reference: Lokalizacja_Zamówienia (table: Fakty_Zamowienia)
ALTER TABLE Fakty_Zamowienia ADD CONSTRAINT Lokalizacja_Zamówienia
    FOREIGN KEY (IdLokalizacji)
    REFERENCES Lokalizacja (IdLokalizacji);

-- Reference: Produkt_Magazyn (table: Fakty_Magazyn)
ALTER TABLE Fakty_Magazyn ADD CONSTRAINT Produkt_Magazyn
    FOREIGN KEY (IdProduktu)
    REFERENCES Produkt (IdProduktu);

-- Reference: PrzedzialKosztuZamowienia_Zamówienia (table: Fakty_Zamowienia)
ALTER TABLE Fakty_Zamowienia ADD CONSTRAINT PrzedKosztuZam_Zam
    FOREIGN KEY (IdPrzedzialuKosztuZamowienia)
    REFERENCES PrzedzialKosztuZamowienia (IdPrzedzialuKosztuZamowienia);

-- Reference: Sprzedaz (fakty)_Lokalizacja (table: Fakty_Sprzedaz)
ALTER TABLE Fakty_Sprzedaz ADD CONSTRAINT Sprzedaz_Lokalizacja
    FOREIGN KEY (IdLokalizacji)
    REFERENCES Lokalizacja (IdLokalizacji);

-- Reference: Sprzedaż (fakty)_Czas (table: Fakty_Sprzedaz)
ALTER TABLE Fakty_Sprzedaz ADD CONSTRAINT Sprzedaż_Czas
    FOREIGN KEY (IdCzasu)
    REFERENCES Czas (IdCzasu);

-- Reference: Sprzedaż_KategoriaCenowa (table: Fakty_Sprzedaz)
ALTER TABLE Fakty_Sprzedaz ADD CONSTRAINT Sprzedaż_KategoriaCenowa
    FOREIGN KEY (IdKategoriiCenowej)
    REFERENCES KategoriaCenowa (IdKategoriiCenowej );

-- Reference: Sprzedaż_OcenaOdKlienta (table: Fakty_Sprzedaz)
ALTER TABLE Fakty_Sprzedaz ADD CONSTRAINT Sprzedaż_OcenaOdKlienta
    FOREIGN KEY (IdOceny)
    REFERENCES Ocena_Od_Klienta (IdOceny);

-- Reference: Sprzedaż_Pracownik (table: Fakty_Sprzedaz)
ALTER TABLE Fakty_Sprzedaz ADD CONSTRAINT Sprzedaż_Pracownik
    FOREIGN KEY (IdPracownika)
    REFERENCES Pracownik (IdPracownika);

-- Reference: Sprzedaż_Produkt (table: Fakty_Sprzedaz)
ALTER TABLE Fakty_Sprzedaz ADD CONSTRAINT Sprzedaż_Produkt
    FOREIGN KEY (IdProduktu)
    REFERENCES Produkt (IdProduktu);

-- Reference: Sprzedaż_Promocja (table: Fakty_Sprzedaz)
ALTER TABLE Fakty_Sprzedaz ADD CONSTRAINT Sprzedaż_Promocja
    FOREIGN KEY (IdPromocji)
    REFERENCES Promocja (IdPromocji);

-- Reference: Sprzedaż_Reklamacja (table: Fakty_Sprzedaz)
ALTER TABLE Fakty_Sprzedaz ADD CONSTRAINT Sprzedaż_Reklamacja
    FOREIGN KEY (IdReklamacji)
    REFERENCES Reklamacja (IdReklamacji);

-- Reference: Sprzedaż_WielkoscTransakcji (table: Fakty_Sprzedaz)
ALTER TABLE Fakty_Sprzedaz ADD CONSTRAINT Sprzedaż_WielkoscTransakcji
    FOREIGN KEY (IdWielkosciTransakcji)
    REFERENCES WielkoscTransakcji (IdWielkosciTransakcji);

-- Reference: Zamówienia_Produkt (table: Fakty_Zamowienia)
ALTER TABLE Fakty_Zamowienia ADD CONSTRAINT Zamówienia_Produkt
    FOREIGN KEY (IdProduktu)
    REFERENCES Produkt (IdProduktu);

-- End of file.

