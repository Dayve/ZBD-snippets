-- indexy dla fakty sprzedaż
DROP INDEX FAKTY_SPRZEDAZ_PRODUKT;
DROP INDEX FAKTY_SPRZEDAZ_WIELKOSC_T;
DROP INDEX FAKTY_SPRZEDAZ_REKLAMACJI;
DROP INDEX FAKTY_SPRZEDAZ_PROMOCJA;
DROP INDEX FAKTY_SPRZEDAZ_PRACOWNIK;
DROP INDEX FAKTY_SPRZEDAZ_TYP_P;
DROP INDEX FAKTY_SPRZEDAZ_LOKALIZACJA;
DROP INDEX FAKTY_SPRZEDAZ_CZAS;
DROP INDEX FAKTY_SPRZEDAZ_KATEGORIA_C;
DROP INDEX FAKTY_SPRZEDAZ_DOSTAWCA;

CREATE BITMAP INDEX FAKTY_SPRZEDAZ_PRODUKT ON fakty_sprzedaz(p.id)
FROM fakty_sprzedaz fs, produkt p
WHERE fs.id_produktu=p.id;

CREATE BITMAP INDEX FAKTY_SPRZEDAZ_WIELKOSC_T ON fakty_sprzedaz(wt.id)
  FROM fakty_sprzedaz fs, Wielkosc_Transakcji wt
WHERE fs.id_wielkosci_transakcji=wt.id;

CREATE BITMAP INDEX FAKTY_SPRZEDAZ_REKLAMACJI ON fakty_sprzedaz(r.id)
  FROM fakty_sprzedaz fs, Reklamacja r
WHERE fs.id_reklamacji=r.id;

CREATE BITMAP INDEX FAKTY_SPRZEDAZ_PROMOCJA ON fakty_sprzedaz(p.id)
  FROM fakty_sprzedaz fs, Promocja p
WHERE fs.id_promocji=p.id;

CREATE BITMAP INDEX FAKTY_SPRZEDAZ_PRACOWNIK ON fakty_sprzedaz(p.id)
  FROM fakty_sprzedaz fs, Pracownik p
WHERE fs.id_pracownika=p.id;

CREATE BITMAP INDEX FAKTY_SPRZEDAZ_TYP_P ON fakty_sprzedaz(tp.id)
  FROM fakty_sprzedaz fs, Typ_produktu tp
WHERE fs.id_typu_produktu=tp.id;

CREATE BITMAP INDEX FAKTY_SPRZEDAZ_LOKALIZACJA ON fakty_sprzedaz(l.id)
  FROM fakty_sprzedaz fs, Lokalizacja l
WHERE fs.id_lokalizacji=l.id;

CREATE BITMAP INDEX FAKTY_SPRZEDAZ_CZAS ON fakty_sprzedaz(c.id)
  FROM fakty_sprzedaz fs, Czas c
WHERE fs.id_czasu=c.id;

CREATE BITMAP INDEX FAKTY_SPRZEDAZ_KATEGORIA_C ON fakty_sprzedaz(kc.id)
  FROM fakty_sprzedaz fs, Kategoria_cenowa kc
WHERE fs.id_kategorii_cenowej=kc.id;

CREATE BITMAP INDEX FAKTY_SPRZEDAZ_DOSTAWCA ON fakty_sprzedaz(d.id)
  FROM fakty_sprzedaz fs, Dostawca d
WHERE fs.id_dostawcy=d.id;

-- indexy dla fakty magazyn
DROP INDEX FAKTY_MAGAZYN_PRODUKT;
DROP INDEX FAKTY_MAGAZYN_TYP_P;
DROP INDEX FAKTY_MAGAZYN_LOKALIZACJA;
DROP INDEX FAKTY_MAGAZYN_CZASU;

CREATE BITMAP INDEX FAKTY_MAGAZYN_PRODUKT ON fakty_magazyn(p.id)
FROM fakty_magazyn fm, produkt p
WHERE fm.id_produktu=p.id;

CREATE BITMAP INDEX FAKTY_MAGAZYN_TYP_P ON fakty_magazyn(tp.id)
FROM fakty_magazyn fm, Typ_produktu tp
WHERE fm.id_typu_produktu=tp.id;

CREATE BITMAP INDEX FAKTY_MAGAZYN_LOKALIZACJA ON fakty_magazyn(l.id)
FROM fakty_magazyn fm, Lokalizacja l
WHERE fm.id_lokalizacji=l.id;

CREATE BITMAP INDEX FAKTY_MAGAZYN_CZASU ON fakty_magazyn(c.id)
FROM fakty_magazyn fm, Czas c
WHERE fm.id_czasu=c.id;

-- indexy dla fakty zamowienia
DROP INDEX FAKTY_ZAMOWIENIA_LOKALIZACJA;
DROP INDEX FAKTY_ZAMOWIENIA_PRZEDZIAL_K;
DROP INDEX FAKTY_ZAMOWIENIA_TYPU_P;
DROP INDEX FAKTY_ZAMOWIENIA_PRODUKT;
DROP INDEX FAKTY_ZAMOWIENIA_CZAS;
DROP INDEX FAKTY_ZAMOWIENIA_DOSTAWCA;

CREATE BITMAP INDEX FAKTY_ZAMOWIENIA_LOKALIZACJA ON fakty_zamowienia(l.id)
FROM fakty_zamowienia fz, Lokalizacja l
WHERE fz.id_lokalizacji=l.id;

CREATE BITMAP INDEX FAKTY_ZAMOWIENIA_PRZEDZIAL_K ON fakty_zamowienia(pk.id)
FROM fakty_zamowienia fz, Przedzial_kosztu_zamowienia pk
WHERE fz.id_przedzialu_kosztu=pk.id;

CREATE BITMAP INDEX FAKTY_ZAMOWIENIA_PRODUKT ON fakty_zamowienia(p.id)
FROM fakty_zamowienia fz, Produkt p
WHERE fz.id_produktu=p.id;

CREATE BITMAP INDEX FAKTY_ZAMOWIENIA_TYPU_P ON fakty_zamowienia(tp.id)
FROM fakty_zamowienia fz, Typ_produktu tp
WHERE fz.id_typu_produktu=tp.id;

CREATE BITMAP INDEX FAKTY_ZAMOWIENIA_CZAS ON fakty_zamowienia(c.id)
FROM fakty_zamowienia fz, Czas c
WHERE fz.id_czasu=c.id;

CREATE BITMAP INDEX FAKTY_ZAMOWIENIA_DOSTAWCA ON fakty_zamowienia(d.id)
FROM fakty_zamowienia fz, Dostawca d
WHERE fz.id_dostawcy=d.id;
