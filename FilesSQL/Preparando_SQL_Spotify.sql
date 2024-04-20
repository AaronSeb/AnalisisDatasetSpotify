use DB_Spotify;
select * from [dbo].[data_spotify_clean];

--importo mi archivo csv 
-- SE UTILIZA NVARCHAR PARA QUE ACEPTE CARACTERES ESPECIALES, COMO NOMBRES CHINOS
-- ESTE ES MI TABLA Y SU TIPO DE DATOS

CREATE TABLE [dbo].[data_spotify_clean] (
[track_id] nvarchar(MAX),
[artists] nvarchar(MAX),
[album_name] nvarchar(MAX),
[track_name] nvarchar(MAX),
[popularity] INT,
[duration_ms] INT,
[explicit] nvarchar(MAX),
[danceability] FLOAT,
[energy] FLOAT,
[key] INT,
[loudness] FLOAT,
[mode] INT,
[speechiness] FLOAT,
[acousticness] FLOAT,
[instrumentalness] FLOAT,
[liveness] FLOAT,
[valence] FLOAT,
[tempo] FLOAT,
[time_signature] INT,
[track_genre] nvarchar(MAX)
)

SELECT * FROM [dbo].[data_spotify]
where N_cod=10005;

sp_help'[data_spotify_prueba]';

-- VERIFICO LA EXISTENCIA DE DATOS QUE SE REPITEN, LO MAXIMO QUE SE REPITE UN DATO SON 9 VECES
-- DEBIDO AL TRACK DE GÉNERO

SELECT track_id,COUNT(*) AS VECES
FROM data_spotify
GROUP BY track_id
HAVING COUNT(*)=9;

SELECT *
FROM
data_spotify
WHERE track_id = '6S3JlDAGk3uu3NtZbPnuhS';

-- DE TODOS MODOS TENGO QUE CREAR UN PRIMARY KEY, SERÁ AUTOINCREMENTAL DEBIDO A QUE ES PARA DIFERENCIAR DE LOS TRACK_ID QUE SE REPITEN

ALTER TABLE data_spotify
ADD N_cod INT IDENTITY(1,1) PRIMARY KEY;



-- PARA VER MIS TABLAS TEMPORALES
SELECT * 
FROM tempdb.sys.tables 
WHERE name LIKE '#TemD';

-- PARA ELIMINARLAS
DROP TABLE #TempData;

-- LO QUE QUIERO ES PASAR EL N_cod A LA PRIMERA POSICIÓN

-- CREO UNA TABLA TEMPORAL PARA ALMACENAR LOS DATOS CON LA NUEVA COLUMNA, EL ROW()
SELECT
	ROW_NUMBER() OVER (ORDER BY N_cod ASC) AS cod,
	[N_cod],
	[track_id],
    [artists], 
    [album_name], 
    [track_name], 
    [popularity], 
    [duration_ms], 
    [explicit], 
    [danceability], 
    [energy], 
    [key], 
    [loudness], 
    [mode], 
    [speechiness], 
    [acousticness], 
    [instrumentalness], 
    [liveness], 
    [valence], 
    [tempo], 
    [time_signature], 
    [track_genre]
INTO #TempData
FROM [dbo].[data_spotify]
ORDER BY cod ASC;

-- AGREGAR 
ALTER TABLE #TempData
ADD CONSTRAINT PK_cod PRIMARY KEY (cod);

SELECT * FROM #TempData
ORDER BY N_cod
--where n_cod=10005;

-- ELIMINA LA COLUMNA COD
ALTER TABLE #TempData
DROP COLUMN cod;




-- VER EL NOMBRE COMPLETO DE LA BASE DE DATOS
SELECT *
FROM tempdb.sys.tables
WHERE name LIKE '#TempData%';

-- NO ME RECONOCE LA TABLA TEMPORAL, TENDRÉ QUE CREAR UNA NUEVA Y PASAR LOS DATOS

CREATE TABLE [dbo].[datos_spotify] (
[N_cod] INT IDENTITY(1,1) PRIMARY KEY,
[track_id] nvarchar(MAX),
[artists] nvarchar(MAX),
[album_name] nvarchar(MAX),
[track_name] nvarchar(MAX),
[popularity] INT,
[duration_ms] INT,
[explicit] nvarchar(MAX),
[danceability] FLOAT,
[energy] FLOAT,
[key] INT,
[loudness] FLOAT,
[mode] INT,
[speechiness] FLOAT,
[acousticness] FLOAT,
[instrumentalness] FLOAT,
[liveness] FLOAT,
[valence] FLOAT,
[tempo] FLOAT,
[time_signature] INT,
[track_genre] nvarchar(MAX)
);

-- PRIMEROD TENGO QUE HABILITAR IDENTITY_INSERT
SET IDENTITY_INSERT datos_spotify ON;

-- INSERTO LOS DATOS QUE TENGO EN MI TABLA TEMPORAL
INSERT INTO datos_spotify ([N_cod],[track_id], [artists], [album_name], [track_name], [popularity], [duration_ms], [explicit], [danceability], [energy], [key], [loudness], [mode], [speechiness], [acousticness], [instrumentalness], [liveness], [valence], [tempo], [time_signature], [track_genre])
SELECT [N_cod],[track_id], [artists], [album_name], [track_name], [popularity], [duration_ms], [explicit], [danceability], [energy], [key], [loudness], [mode], [speechiness], [acousticness], [instrumentalness], [liveness], [valence], [tempo], [time_signature], [track_genre]
FROM #TempData
ORDER BY N_cod;

SELECT * FROM datos_spotify
-- where N_cod=10005
-- ORDER BY N_cod

-- AHORA TENGO QUE DESHABILITARLO
SET IDENTITY_INSERT datos_spotify OFF;


----------------------------------------AQUI----------------------------------
-- LIMPIANDO CARACTERES | POR ";"
SELECT N_cod,track_name FROM [dbo].[datos_spotify]
WHERE mode like'%|%';

UPDATE [dbo].[datos_spotify]
SET track_name = REPLACE(track_name, '|', ';')
WHERE track_name LIKE '%|%';


SELECT *FROM [dbo].[data_new_spotify]
WHERE artists='LISA';

SELECT * FROM [dbo].[data_new_spotify];