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


-- tables
-- Table: Cena_Produktu
CREATE TABLE Cena_Produktu (
    Id number(8)  DEFAULT ON NOT NULL,
    Id_Produktu number(6)  NOT NULL,
    Cena number(6)  NOT NULL,
    Od date  NOT NULL,
    Do date  NOT NULL,
    CONSTRAINT Cena_Produktu_pk PRIMARY KEY (Id)
) ;

-- Table: Dostawca
CREATE TABLE Dostawca (
    Id number(4)  DEFAULT ON NOT NULL,
    Nazwa varchar2(50)  NOT NULL,
    CONSTRAINT Dostawca_pk PRIMARY KEY (Id)
) ;

-- Table: Dział
CREATE TABLE Dział (
    Id number(3)  DEFAULT ON NOT NULL,
    Nazwa varchar2(30)  NOT NULL,
    CONSTRAINT Dział_pk PRIMARY KEY (Id)
) ;

-- Table: Kategoria_Produktu
CREATE TABLE Kategoria_Produktu (
    Id number(3)  DEFAULT ON NOT NULL,
    Nazwa varchar2(50)  NOT NULL,
    Id_Działu number(3)  NOT NULL,
    CONSTRAINT Kategoria_Produktu_pk PRIMARY KEY (Id)
) ;

-- Table: Magazyn
CREATE TABLE Magazyn (
    Id_Oddziału number(4)  NOT NULL,
    Id_Produktu number(6)  NOT NULL,
    Liczba_Produktów number(7)  NOT NULL,
    Czas timestamp  NOT NULL,
    CONSTRAINT Magazyn_pk PRIMARY KEY (Id_Oddziału,Id_Produktu)
) ;

-- Table: Ocena_Od_Klienta
CREATE TABLE Ocena_Od_Klienta (
    Id number(1)  DEFAULT ON NOT NULL,
    Ocena varchar2(30)  NOT NULL,
    CONSTRAINT Ocena_Od_Klienta_pk PRIMARY KEY (Id)
) ;

-- Table: Oddział
CREATE TABLE Oddział (
    Id number(4)  DEFAULT ON NOT NULL,
    Nazwa varchar2(50)  NOT NULL,
    Miasto varchar2(25)  NOT NULL,
    Województwo varchar2(50)  NOT NULL,
    Ulica_I_Numer varchar2(50)  NOT NULL,
    CONSTRAINT Oddział_pk PRIMARY KEY (Id)
) ;

-- Table: Pracownik
CREATE TABLE Pracownik (
    Id number(5)  DEFAULT ON NOT NULL,
    Imię varchar2(50)  NOT NULL,
    Nazwisko varchar2(50)  NOT NULL,
    CONSTRAINT Pracownik_pk PRIMARY KEY (Id)
) ;

-- Table: Produkt
CREATE TABLE Produkt (
    Id number(6)  DEFAULT ON NOT NULL,
    Id_Kategorii number(3)  NOT NULL,
    Id_Działu number(3)  NOT NULL,
    Nazwa varchar2(50)  NOT NULL,
    CONSTRAINT Produkt_pk PRIMARY KEY (Id)
) ;

-- Table: Produkt_Zamówienie
CREATE TABLE Produkt_Zamówienie (
    Id_Produktu number(6)  NOT NULL,
    Id_Zamówienia number(6)  NOT NULL,
    Liczba_Sztuk number(4)  NOT NULL,
    Koszt_Zamówienia_Sztuki number(5)  NOT NULL,
    CONSTRAINT Produkt_Zamówienie_pk PRIMARY KEY (Id_Produktu,Id_Zamówienia)
) ;

-- Table: Promocje
CREATE TABLE Promocje (
    Id number(6)  DEFAULT ON NOT NULL,
    Id_Produktu number(6)  NOT NULL,
    Obniżka_Procentowa number(2)  NULL,
    Od date  NOT NULL,
    Do date  NOT NULL,
    CONSTRAINT Promocje_pk PRIMARY KEY (Id)
) ;

-- Table: Reklamacja
CREATE TABLE Reklamacja (
    Id number(2)  DEFAULT ON NOT NULL,
    Powód varchar2(255)  NOT NULL,
    CONSTRAINT Reklamacja_pk PRIMARY KEY (Id)
) ;

-- Table: Sprzedaż
CREATE TABLE Sprzedaż (
    Id number(12)  DEFAULT ON NOT NULL,
    Id_Reklamacji number(2)  NULL,
    Id_Oceny number(1)  NULL,
    Id_Produktu number(6)  NOT NULL,
    Id_Pracownika number(5)  NOT NULL,
    Liczba_Produktów number(4)  NOT NULL,
    Czas timestamp  NOT NULL,
    Zysk number(5)  NOT NULL,
    Numer_Transakcji number(16)  NOT NULL,
    CONSTRAINT Sprzedaż_pk PRIMARY KEY (Id)
) ;

-- Table: Zamówienia
CREATE TABLE Zamówienia (
    Id number(6)  DEFAULT ON NOT NULL,
    Id_Oddziału number(4)  NOT NULL,
    Id_Dostawcy number(4)  NOT NULL,
    Koszt_Zamówienia number(8,2)  NOT NULL,
    Data_Zamówienia date  NOT NULL,
    CONSTRAINT Zamówienia_pk PRIMARY KEY (Id)
) ;

-- foreign keys
-- Reference: CenaProduktu_Produkt (table: Cena_Produktu)
ALTER TABLE Cena_Produktu ADD CONSTRAINT CenaProduktu_Produkt
    FOREIGN KEY (Id_Produktu)
    REFERENCES Produkt (Id);

-- Reference: Kategoria_Produktu_Dział (table: Kategoria_Produktu)
ALTER TABLE Kategoria_Produktu ADD CONSTRAINT Kategoria_Produktu_Dział
    FOREIGN KEY (Id_Działu)
    REFERENCES Dział (Id);

-- Reference: Magazyn_Oddział (table: Magazyn)
ALTER TABLE Magazyn ADD CONSTRAINT Magazyn_Oddział
    FOREIGN KEY (Id_Oddziału)
    REFERENCES Oddział (Id);

-- Reference: Magazyn_Produkt (table: Magazyn)
ALTER TABLE Magazyn ADD CONSTRAINT Magazyn_Produkt
    FOREIGN KEY (Id_Produktu)
    REFERENCES Produkt (Id);

-- Reference: ProduktZamówienie_Produkt (table: Produkt_Zamówienie)
ALTER TABLE Produkt_Zamówienie ADD CONSTRAINT ProduktZamówienie_Produkt
    FOREIGN KEY (Id_Produktu)
    REFERENCES Produkt (Id);

-- Reference: ProduktZamówienie_Zamówienia (table: Produkt_Zamówienie)
ALTER TABLE Produkt_Zamówienie ADD CONSTRAINT ProduktZamówienie_Zamówienia
    FOREIGN KEY (Id_Zamówienia)
    REFERENCES Zamówienia (Id);

-- Reference: Produkt_Dział (table: Produkt)
ALTER TABLE Produkt ADD CONSTRAINT Produkt_Dział
    FOREIGN KEY (Id_Działu)
    REFERENCES Dział (Id);

-- Reference: Produkt_KategoriaProduktu (table: Produkt)
ALTER TABLE Produkt ADD CONSTRAINT Produkt_KategoriaProduktu
    FOREIGN KEY (Id_Kategorii)
    REFERENCES Kategoria_Produktu (Id);

-- Reference: Produkt_Promocje (table: Promocje)
ALTER TABLE Promocje ADD CONSTRAINT Produkt_Promocje
    FOREIGN KEY (Id_Produktu)
    REFERENCES Produkt (Id);

-- Reference: Sprzedaż_OcenaOdKlienta (table: Sprzedaż)
ALTER TABLE Sprzedaż ADD CONSTRAINT Sprzedaż_OcenaOdKlienta
    FOREIGN KEY (Id_Oceny)
    REFERENCES Ocena_Od_Klienta (Id);

-- Reference: Sprzedaż_Pracownik (table: Sprzedaż)
ALTER TABLE Sprzedaż ADD CONSTRAINT Sprzedaż_Pracownik
    FOREIGN KEY (Id_Pracownika)
    REFERENCES Pracownik (Id);

-- Reference: Sprzedaż_Produkt (table: Sprzedaż)
ALTER TABLE Sprzedaż ADD CONSTRAINT Sprzedaż_Produkt
    FOREIGN KEY (Id_Produktu)
    REFERENCES Produkt (Id);

-- Reference: Sprzedaż_Reklamacja (table: Sprzedaż)
ALTER TABLE Sprzedaż ADD CONSTRAINT Sprzedaż_Reklamacja
    FOREIGN KEY (Id_Reklamacji)
    REFERENCES Reklamacja (Id);

-- Reference: Zamówienia_Dostawca (table: Zamówienia)
ALTER TABLE Zamówienia ADD CONSTRAINT Zamówienia_Dostawca
    FOREIGN KEY (Id_Dostawcy)
    REFERENCES Dostawca (Id);

-- Reference: Zamówienia_Oddział (table: Zamówienia)
ALTER TABLE Zamówienia ADD CONSTRAINT Zamówienia_Oddział
    FOREIGN KEY (Id_Oddziału)
    REFERENCES Oddział (Id);
	
