# Lichess-Data-Analysis
I analyzed a dataset published by Lichess that consisting of 20058 chess matches.  It focuses on player statistics such as wins, ratings, and categorizing players based on their ratings. The queries include both standard and optimized versions for better performance. In this project the data analysis is visualized using Power BI.

Queries Included: 


Player Table Creation and Insertion: Creates a new dbo.players table to store unique player IDs and their wins from the games in the dbo.games2 table.

Wins Update:Updates the wins column for each player by counting the number of games they won as either the white or black player.
Optimized Version: Uses an inner join and a union to calculate the wins more efficiently.

Player Rating Update: Updates the player's rating based on the maximum rating from the games they participated in.
Optimized Version: Uses a CTE to fetch the maximum rating for each player and update it efficiently.

Rating Grouping: Groups players into rating ranges (under1000, 1000-1500, 1500-2000, over2000) and counts how many players fall into each range.

Game Status Count: Counts the number of games for each victory status (mate, resign, draw, out of time).
