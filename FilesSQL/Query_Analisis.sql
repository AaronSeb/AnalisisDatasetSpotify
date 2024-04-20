
SELECT * FROM datos_spotify;
--AGRUPAR POR ARTISTAS, CONTAR CUANTAS CANCIONES TIENEN
CREATE VIEW v_canciones_x_artistas
AS
	SELECT artists,COUNT(track_id) CANCIONES
	FROM [dbo].[data_new_spotify]
	GROUP BY artists;

SELECT artists,track_id,track_name,danceability,track_genre
FROM [dbo].[data_new_spotify]
where artists = 'AC/DC'

SELECT *
FROM [dbo].[data_new_spotify]
where artists = 'TERRA'



-- LA CANCION MÁS POPULAR
CREATE VIEW v_cancion_mas_popular
AS
	SELECT track_name,popularity,track_genre
	FROM data_new_spotify
	WHERE popularity = 
	(SELECT MAX(popularity)
	FROM datos_spotify);

-- QUE CANCION ESTÁ EN EL TOP 10 MÁS POPULARES, DE TODOS LOS GÉNEROS

	WITH ranking AS(
	SELECT track_id,artists,track_name,track_genre, popularity,DENSE_RANK() OVER(ORDER BY popularity DESC) as rnk
	FROM [dbo].[data_new_spotify]
	)

	SELECT * FROM ranking
	WHERE rnk<=10
	ORDER BY rnk;

--QUE CANCIÓN ESTÁ EN EL TOP 5 POR GENERO

WITH cancionesxgenero AS(
	SELECT DISTINCT track_name,track_genre, popularity
	FROM [dbo].[data_new_spotify]
	GROUP BY track_genre,track_name,popularity
)
SELECT * 
FROM
	(
		SELECT *, RANK() OVER(PARTITION BY track_genre ORDER BY popularity DESC) as rnk
		FROM cancionesxgenero
	) AS C1
WHERE rnk<=5;

--CUANTAS CANCIONES HAY POR GENERO
SELECT track_genre,COUNT(DISTINCT track_id) total_canciones
FROM data_new_spotify
GROUP BY track_genre
ORDER BY total_canciones DESC;

-- EL PORCENTAJE DE CANCIONES QUE TIENEN LETRAS EXPLICITAS 
SELECT (CAST(T1.EXPLICIT AS FLOAT)/T1.TOTAL)*100 AS PERCENT_EXPLICIT,
(CAST(T1.NO_EXPLICIT AS FLOAT)/T1.TOTAL)*100 AS PERCENT_EXPLICIT
FROM
	(SELECT 
		COUNT(CASE WHEN explicit =1 THEN 1 END) AS EXPLICIT,
		COUNT(CASE WHEN explicit =0 THEN 1 END) AS NO_EXPLICIT,
		COUNT(*)AS TOTAL
	FROM data_new_spotify
	) AS T1;


-- PORCENTAJE DE QUE GENERO ES LA QUE TIENE MÁS LETRAS EXPLÍCITAS

	WITH group_genero_explicit AS(
	SELECT 
	track_genre,
	COUNT(CASE WHEN explicit =1 THEN 1 END) AS EXPLICIT,
	COUNT(CASE WHEN explicit =0 THEN 1 END) AS NO_EXPLICIT,
	COUNT(*)AS TOTAL
	FROM data_new_spotify
	GROUP BY track_genre)

	SELECT
	track_genre,
	(CAST(EXPLICIT AS FLOAT)/TOTAL)*100 AS PORCENTAJE_EXPLICIT,
	(CAST(NO_EXPLICIT AS FLOAT)/TOTAL)*100 AS PORCENTAJE_NO_EXPLICIT
	FROM group_genero_explicit
	ORDER BY PORCENTAJE_EXPLICIT DESC


-- QUE  CANCION ES MÁS DANCEABILITY
SELECT track_name, MAX(danceability) Danceability
FROM
data_new_spotify
GROUP BY track_name
ORDER BY MAX(danceability) desc;

SELECT track_name,danceability
FROM datos_spotify
WHERE danceability = (
	SELECT MAX(danceability)
	from data_new_spotify
	)

-- QUE GENERO ES MÁS BAILABLE

SELECT track_genre, SUM(danceability) TOTAL_DANCEABILITY
FROM
data_new_spotify
GROUP BY track_genre
ORDER BY SUM(danceability) DESC;

--CUANTOS ARTISTAS 
SELECT COUNT(DISTINCT(artists)) CANTIDAD_ARTISTAS
FROM data_new_spotify;

SELECT DISTINCT(artists)
FROM data_new_spotify
ORDER BY artists;

-- CUANTAS CANCIONES
SELECT COUNT(DISTINCT(track_name)) CANTIDAD_CANCIONES
FROM data_new_spotify;

