-- tables
-- Table: Czas
CREATE TABLE Czas (
Id integer  GENERATED BY DEFAULT ON NULL AS IDENTITY,
Data date  NOT NULL,
Godzina integer  NOT NULL,
Dzien_Tygodnia varchar2(20)  NOT NULL,
Miesiac integer  NOT NULL,
Kwartal integer  NOT NULL,
Rok integer  NOT NULL,
CONSTRAINT Czas_pk PRIMARY KEY (Id))

PARTITION BY LIST (miesiac)
 (
    PARTITION styczen VALUES (1),
    PARTITION luty VALUES (2),
    PARTITION marzec VALUES (3),
    PARTITION kwiecien VALUES (4),
    PARTITION maj VALUES (5),
    PARTITION czerwiec VALUES (6),
    PARTITION lipiec VALUES (7),
    PARTITION sierpien VALUES (8),
    PARTITION wrzesien VALUES (9),
    PARTITION pazdziernik VALUES (10),
    PARTITION listopad VALUES (11),
    PARTITION grudzien VALUES (12)
 );

-- Table: Dostawca
CREATE TABLE Dostawca (
    Id integer  GENERATED BY DEFAULT ON NULL AS IDENTITY,
    Nazwa varchar2(50)  NOT NULL,
    CONSTRAINT Dostawca_pk PRIMARY KEY (Id)
) ;

-- Table: Fakty_Magazyn
CREATE TABLE Fakty_Magazyn (
    Id integer  GENERATED BY DEFAULT ON NULL AS IDENTITY,
    Id_Produktu integer  NOT NULL,
    Id_Typu_Produktu Integer  NOT NULL,
    Id_Lokalizacji integer  NOT NULL,
    Id_Czasu integer  NOT NULL,
    Liczba_Sztuk integer  NOT NULL,
    CONSTRAINT Fakty_Magazyn_pk PRIMARY KEY (Id)
) ;

-- Table: Fakty_Sprzedaz
CREATE TABLE Fakty_Sprzedaz (
    Id integer  GENERATED BY DEFAULT ON NULL AS IDENTITY,
    Id_Wielkosci_Transakcji integer  NOT NULL,
    Id_Reklamacji integer  NOT NULL,
    Id_Promocji integer  NOT NULL,
    Id_Pracownika integer  NOT NULL,
    Id_Produktu integer  NOT NULL,
    Id_Typu_Produktu Integer  NOT NULL,
    Id_Lokalizacji integer  NOT NULL,
    Id_Czasu integer  NOT NULL,
    Id_Kategorii_Cenowej integer  NOT NULL,
    Id_Oceny integer  NOT NULL,
    Id_Dostawcy integer  NOT NULL,
    Zysk number(7,2)  NOT NULL,
    Liczba_Sztuk integer  NOT NULL,
    CONSTRAINT Fakty_Sprzedaz_pk PRIMARY KEY (Id)
) ;

-- Table: Fakty_Zamowienia
CREATE TABLE Fakty_Zamowienia (
    Id integer  GENERATED BY DEFAULT ON NULL AS IDENTITY,
    Id_Lokalizacji integer  NOT NULL,
    Id_Przedzialu_Kosztu integer  NOT NULL,
    Id_Produktu integer  NOT NULL,
    Id_Typu_Produktu Integer  NOT NULL,
    Id_Czasu integer  NOT NULL,
    Id_Dostawcy integer  NOT NULL,
    Liczba_Sztuk integer  NOT NULL,
    CONSTRAINT Fakty_Zamowienia_pk PRIMARY KEY (Id)
) ;

-- Table: Kategoria_Cenowa
CREATE TABLE Kategoria_Cenowa (
    Id integer  GENERATED BY DEFAULT ON NULL AS IDENTITY,
    Od_PLN integer  NOT NULL,
    Do_PLN integer  NOT NULL,
    CONSTRAINT KategoriaCenowa_pk PRIMARY KEY (Id)
) ;

-- Table: Lokalizacja
CREATE TABLE Lokalizacja (
    Id integer  GENERATED BY DEFAULT ON NULL AS IDENTITY,
    Wojewodztwo varchar2(50)  NOT NULL,
    Miasto varchar2(50)  NOT NULL,
    Oddzial varchar2(50)  NOT NULL,
    CONSTRAINT Lokalizacja_pk PRIMARY KEY (Id)
) ;

-- Table: Ocena_Od_Klienta
CREATE TABLE Ocena_Od_Klienta (
    Id integer  GENERATED BY DEFAULT ON NULL AS IDENTITY,
    Ocena varchar2(30)  NOT NULL,
    CONSTRAINT Ocena_Od_Klienta_pk PRIMARY KEY (Id)
) ;

-- Table: Pracownik
CREATE TABLE Pracownik (
    Id integer  GENERATED BY DEFAULT ON NULL AS IDENTITY,
    Imie varchar2(50)  NOT NULL,
    Nazwisko varchar2(50)  NOT NULL,
    CONSTRAINT Pracownik_pk PRIMARY KEY (Id)
) ;

-- Table: Produkt
CREATE TABLE Produkt (
    Id integer  GENERATED BY DEFAULT ON NULL AS IDENTITY,
    Nazwa varchar2(50)  NOT NULL,
    CONSTRAINT Produkt_pk PRIMARY KEY (Id)
) ;

-- Table: Promocja
CREATE TABLE Promocja (
    Id integer  GENERATED BY DEFAULT ON NULL AS IDENTITY,
    Od_Procentowo integer  NOT NULL,
    Do_Procentowo integer  NOT NULL,
    CONSTRAINT Promocja_pk PRIMARY KEY (Id)
) ;

-- Table: Przedzial_Kosztu_Zamowienia
CREATE TABLE Przedzial_Kosztu_Zamowienia (
    Id integer  GENERATED BY DEFAULT ON NULL AS IDENTITY,
    Od_PLN integer  NOT NULL,
    Do_PLN integer  NOT NULL,
    CONSTRAINT PrzedzialKosztuZamowienia_pk PRIMARY KEY (Id)
) ;

-- Table: Reklamacja
CREATE TABLE Reklamacja (
    Id integer  GENERATED BY DEFAULT ON NULL AS IDENTITY,
    Powod varchar2(255)  NOT NULL,
    CONSTRAINT Reklamacja_pk PRIMARY KEY (Id)
) ;

-- Table: Typ_Produktu
CREATE TABLE Typ_Produktu (
    Id integer  GENERATED BY DEFAULT ON NULL AS IDENTITY,
    Dzial_Produktu varchar2(50)  NOT NULL,
    Kategoria_Produktu varchar2(50)  NOT NULL,
    CONSTRAINT Typ_Produktu_pk PRIMARY KEY (Id)
) ;

-- Table: Wielkosc_Transakcji
CREATE TABLE Wielkosc_Transakcji (
    Id integer  GENERATED BY DEFAULT ON NULL AS IDENTITY,
    Od_PLN integer  NOT NULL,
    Do_PLN integer  NOT NULL,
    CONSTRAINT WielkoscTransakcji_pk PRIMARY KEY (Id)
) ;

-- foreign keys
-- Reference: Czas_Magazyn (table: Fakty_Magazyn)
ALTER TABLE Fakty_Magazyn ADD CONSTRAINT Czas_Magazyn
    FOREIGN KEY (Id_Czasu)
    REFERENCES Czas (Id);

-- Reference: Czas_Zamowienia (table: Fakty_Zamowienia)
ALTER TABLE Fakty_Zamowienia ADD CONSTRAINT Czas_Zamowienia
    FOREIGN KEY (Id_Czasu)
    REFERENCES Czas (Id);

-- Reference: Dostawca_Sprzedaz (table: Fakty_Sprzedaz)
ALTER TABLE Fakty_Sprzedaz ADD CONSTRAINT Dostawca_Sprzedaz
    FOREIGN KEY (Id_Dostawcy)
    REFERENCES Dostawca (Id);

-- Reference: Dostawca_Zamowienia (table: Fakty_Zamowienia)
ALTER TABLE Fakty_Zamowienia ADD CONSTRAINT Dostawca_Zamowienia
    FOREIGN KEY (Id_Dostawcy)
    REFERENCES Dostawca (Id);

-- Reference: Fakty_Magazyn_Dzial (table: Fakty_Magazyn)
ALTER TABLE Fakty_Magazyn ADD CONSTRAINT Fakty_Magazyn_Dzial
    FOREIGN KEY (Id_Typu_Produktu)
    REFERENCES Typ_Produktu (Id);

-- Reference: Fakty_Sprzedaz_Czas (table: Fakty_Sprzedaz)
ALTER TABLE Fakty_Sprzedaz ADD CONSTRAINT Fakty_Sprzedaz_Czas
    FOREIGN KEY (Id_Czasu)
    REFERENCES Czas (Id);

-- Reference: Fakty_Sprzedaz_Dzial (table: Fakty_Sprzedaz)
ALTER TABLE Fakty_Sprzedaz ADD CONSTRAINT Fakty_Sprzedaz_Dzial
    FOREIGN KEY (Id_Typu_Produktu)
    REFERENCES Typ_Produktu (Id);

-- Reference: Fakty_Zamowienia_Dzial (table: Fakty_Zamowienia)
ALTER TABLE Fakty_Zamowienia ADD CONSTRAINT Fakty_Zamowienia_Dzial
    FOREIGN KEY (Id_Typu_Produktu)
    REFERENCES Typ_Produktu (Id);

-- Reference: Lokalizacja_Magazyn (table: Fakty_Magazyn)
ALTER TABLE Fakty_Magazyn ADD CONSTRAINT Lokalizacja_Magazyn
    FOREIGN KEY (Id_Lokalizacji)
    REFERENCES Lokalizacja (Id);

-- Reference: Lokalizacja_Zamowienia (table: Fakty_Zamowienia)
ALTER TABLE Fakty_Zamowienia ADD CONSTRAINT Lokalizacja_Zamowienia
    FOREIGN KEY (Id_Lokalizacji)
    REFERENCES Lokalizacja (Id);

-- Reference: Produkt_Magazyn (table: Fakty_Magazyn)
ALTER TABLE Fakty_Magazyn ADD CONSTRAINT Produkt_Magazyn
    FOREIGN KEY (Id_Produktu)
    REFERENCES Produkt (Id);

-- Reference: PrzedKosztuZam_Zam (table: Fakty_Zamowienia)
ALTER TABLE Fakty_Zamowienia ADD CONSTRAINT PrzedKosztuZam_Zam
    FOREIGN KEY (Id_Przedzialu_Kosztu)
    REFERENCES Przedzial_Kosztu_Zamowienia (Id);

-- Reference: Sprzedaz_KategoriaCenowa (table: Fakty_Sprzedaz)
ALTER TABLE Fakty_Sprzedaz ADD CONSTRAINT Sprzedaz_KategoriaCenowa
    FOREIGN KEY (Id_Kategorii_Cenowej)
    REFERENCES Kategoria_Cenowa (Id);

-- Reference: Sprzedaz_Lokalizacja (table: Fakty_Sprzedaz)
ALTER TABLE Fakty_Sprzedaz ADD CONSTRAINT Sprzedaz_Lokalizacja
    FOREIGN KEY (Id_Lokalizacji)
    REFERENCES Lokalizacja (Id);

-- Reference: Sprzedaz_OcenaOdKlienta (table: Fakty_Sprzedaz)
ALTER TABLE Fakty_Sprzedaz ADD CONSTRAINT Sprzedaz_OcenaOdKlienta
    FOREIGN KEY (Id_Oceny)
    REFERENCES Ocena_Od_Klienta (Id);

-- Reference: Sprzedaz_Pracownik (table: Fakty_Sprzedaz)
ALTER TABLE Fakty_Sprzedaz ADD CONSTRAINT Sprzedaz_Pracownik
    FOREIGN KEY (Id_Pracownika)
    REFERENCES Pracownik (Id);

-- Reference: Sprzedaz_Produkt (table: Fakty_Sprzedaz)
ALTER TABLE Fakty_Sprzedaz ADD CONSTRAINT Sprzedaz_Produkt
    FOREIGN KEY (Id_Produktu)
    REFERENCES Produkt (Id);

-- Reference: Sprzedaz_Promocja (table: Fakty_Sprzedaz)
ALTER TABLE Fakty_Sprzedaz ADD CONSTRAINT Sprzedaz_Promocja
    FOREIGN KEY (Id_Promocji)
    REFERENCES Promocja (Id);

-- Reference: Sprzedaz_Reklamacja (table: Fakty_Sprzedaz)
ALTER TABLE Fakty_Sprzedaz ADD CONSTRAINT Sprzedaz_Reklamacja
    FOREIGN KEY (Id_Reklamacji)
    REFERENCES Reklamacja (Id);

-- Reference: Sprzedaz_WielkoscTransakcji (table: Fakty_Sprzedaz)
ALTER TABLE Fakty_Sprzedaz ADD CONSTRAINT Sprzedaz_WielkoscTransakcji
    FOREIGN KEY (Id_Wielkosci_Transakcji)
    REFERENCES Wielkosc_Transakcji (Id);

-- Reference: Zamowienia_Produkt (table: Fakty_Zamowienia)
ALTER TABLE Fakty_Zamowienia ADD CONSTRAINT Zamowienia_Produkt
    FOREIGN KEY (Id_Produktu)
    REFERENCES Produkt (Id);

