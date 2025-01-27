SELECT TOP 10 * FROM dbo.games2;

SELECT COUNT(*) AS TotalRows FROM dbo.games2;



CREATE TABLE dbo.players (
	player_id VARCHAR(50) PRIMARY KEY,
	wins INT
);


INSERT dbo.players (player_id)
SELECT distinct white_id
FROM dbo.games2;

INSERT dbo.players (player_id)
SELECT distinct black_id
FROM dbo.games2;

SELECT * FROM dbo.players
ORDER BY wins DESC;

SELECT COUNT(*) AS TotalRows FROM dbo.players;


--Ýlk sorgu
UPDATE dbo.players
SET wins = (
    SELECT COUNT(*)
    FROM dbo.games2
    WHERE (dbo.games2.white_id = dbo.players.player_id AND dbo.games2.winner = 'white')
       OR (dbo.games2.black_id = dbo.players.player_id AND dbo.games2.winner = 'black')
);

--Optimize edilmiþ sorgu
UPDATE d
SET wins = t.wins
FROM dbo.players d
INNER JOIN (
    SELECT 
        white_id AS player_id, COUNT(*) AS wins
    FROM dbo.games2
    WHERE winner = 'white'
    GROUP BY white_id
    UNION ALL
    SELECT 
        black_id AS player_id, COUNT(*) AS wins
    FROM dbo.games2
    WHERE winner = 'black'
    GROUP BY black_id
) t
ON d.player_id = t.player_id;

SELECT player_id, wins 
FROM dbo.players
WHERE player_id = '29rus';





SELECT DATEADD(SECOND, CAST(TRY_CAST(REPLACE(REPLACE(created_at, ',', '.'), 'E', 'e') AS FLOAT) / 1000000000 AS BIGINT), '2018-01-01') AS converted_date
FROM dbo.games2;


SELECT 
    REPLACE(REPLACE(created_at, ',', '.'), 'E', 'e') AS formatted_value,
    TRY_CAST(REPLACE(REPLACE(created_at, ',', '.'), 'E', 'e') AS FLOAT) AS float_value
FROM dbo.games2;

SELECT DATEADD(SECOND, CAST(TRY_CAST(REPLACE(REPLACE(created_at, ',', '.'), 'E', 'e') AS FLOAT) / 1000000 AS BIGINT), '1970-01-01') AS converted_date
FROM dbo.games2;

ALTER TABLE dbo.players
ADD rating INT;

SELECT * FROM dbo.players;


--ilk sorgu
UPDATE dbo.players
SET rating = (
    SELECT MAX(rating)
    FROM (
        SELECT 
            CASE 
                WHEN g.white_id = p.player_id THEN g.white_rating
                WHEN g.black_id = p.player_id THEN g.black_rating
                ELSE NULL
            END AS rating
        FROM dbo.games2 g
        WHERE g.white_id = p.player_id OR g.black_id = p.player_id
    ) AS player_ratings
)
FROM dbo.players p;

--optimize edilmiþ yeni sorgu
WITH PlayerRatings AS (
    SELECT 
        player_id,
        MAX(rating) AS max_rating
    FROM (
        SELECT white_id AS player_id, white_rating AS rating
        FROM dbo.games2
        UNION ALL
        SELECT black_id AS player_id, black_rating AS rating
        FROM dbo.games2
    ) AS all_ratings
    GROUP BY player_id
)
UPDATE p
SET rating = pr.max_rating
FROM dbo.players p
JOIN PlayerRatings pr
ON p.player_id = pr.player_id;



SELECT 
    CASE
        WHEN rating < 1000 THEN 'under1000'
        WHEN rating BETWEEN 1000 AND 1500 THEN '1000-1500'
        WHEN rating BETWEEN 1501 AND 2000 THEN '1500-2000'
        ELSE 'over2000'
    END AS rating_group,
    COUNT(*) AS player_count
FROM dbo.players
GROUP BY 
    CASE
        WHEN rating < 1000 THEN 'under1000'
        WHEN rating BETWEEN 1000 AND 1500 THEN '1000-1500'
        WHEN rating BETWEEN 1501 AND 2000 THEN '1500-2000'
        ELSE 'over2000'
    END;



WITH RatingGroups AS (
    SELECT 
        CASE
            WHEN rating < 1000 THEN 'under1000'
            WHEN rating BETWEEN 1000 AND 1500 THEN '1000-1500'
            WHEN rating BETWEEN 1501 AND 2000 THEN '1500-2000'
            ELSE 'over2000'
        END AS rating_group,
        COUNT(*) AS player_count
    FROM dbo.players
    GROUP BY 
        CASE
            WHEN rating < 1000 THEN 'under1000'
            WHEN rating BETWEEN 1000 AND 1500 THEN '1000-1500'
            WHEN rating BETWEEN 1501 AND 2000 THEN '1500-2000'
            ELSE 'over2000'
        END
)
SELECT rating_group, player_count
FROM RatingGroups
ORDER BY 
    CASE rating_group
        WHEN 'under1000' THEN 1
        WHEN '1000-1500' THEN 2
        WHEN '1500-2000' THEN 3
        WHEN 'over2000' THEN 4
    END;

SELECT * FROM dbo.games2;

SELECT 
    victory_status,
    COUNT(*) AS status_count
FROM 
    dbo.games2
GROUP BY 
    victory_status;

SELECT TOP 15 
    increment_code,
    COUNT(*) AS increment_code_count
FROM 
    dbo.games2
GROUP BY 
    increment_code
ORDER BY increment_code_count DESC;

