DECLARE
    l_dostawcow NUMBER;
BEGIN
    SELECT max(id) INTO l_dostawcow FROM zbd_staging.dostawca;

	-- Dostawcy:
	INSERT INTO zbd_warehouse.dostawca (id, nazwa)
	SELECT id+l_dostawcow, nazwa
	FROM zbd_staging.dostawca;

	-- Oddziały -> lokalizacje:
	INSERT INTO zbd_warehouse.lokalizacja (wojewodztwo, miasto, oddzial)
	SELECT województwo, miasto, nazwa
	FROM zbd_staging.oddział;

	
END;
