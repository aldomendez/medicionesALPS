-- Describe el contenido de la tabla que contiene los datos
-- de medicion de ALPS lens
CREATE Table medicion_alps (
	-- "Datos estandard" (todas las tablas los llevan)
	serial_num		varchar(12),
	process 		varchar(12), --TOSA/ROSA
	measured_date	date DEFAULT (sysdate),
	system_id		varchar(15),
	carrier			varchar(12),
	carrier_site	varchar(5),
	user_id			varchar(15),
	comments		varchar(500),
	passfail		varchar(1),
	-------------------------------------------------
	-- Datos de los shear test
	MEAS_X			number,
	MEAS_Y			number,
	MEAS_T			number
)

