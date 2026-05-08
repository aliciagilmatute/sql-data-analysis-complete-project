CREATE OR REPLACE FUNCTION gold.DATE_DIFF 
(
	format TEXT,
	date_1 DATE,
	date_2 DATE
)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
	v_start DATE;
	v_end DATE;
	v_days INT;
	v_months INT;
BEGIN
	-- Normalizar orden (siempre date_1 <= date_2)
	IF date_1 <= date_2 THEN
		v_start := date_1;
		v_end := date_2;
	ELSE
		v_start := date_2;
		v_end := date_1;
	END IF;

	-- diferencia en días base
	v_days := v_end - v_start;

	CASE LOWER(format)

		WHEN 'day' THEN
			RETURN v_days;

		WHEN 'week' THEN
			RETURN (v_days / 7)::INT;

		WHEN 'month' THEN
			-- cálculo más preciso de meses (años + meses)
			v_months :=
				(DATE_PART('year', AGE(v_end, v_start)) * 12
				+ DATE_PART('month', AGE(v_end, v_start)))::INT;

			RETURN v_months;

		WHEN 'year' THEN
			RETURN DATE_PART('year', AGE(v_end, v_start))::INT;

		ELSE
			RAISE EXCEPTION 'Formato no soportado: %', format;

	END CASE;

END;
$$;