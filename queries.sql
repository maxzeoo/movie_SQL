<?xml version="1.0" encoding="UTF-8"?><sqlb_project><db path="movie.db" readonly="0" foreign_keys="1" case_sensitive_like="0" temp_store="0" wal_autocheckpoint="1000" synchronous="2"/><attached/><window><main_tabs open="structure browser pragmas query" current="3"/></window><tab_structure><column_width id="0" width="300"/><column_width id="1" width="0"/><column_width id="2" width="100"/><column_width id="3" width="1638"/><column_width id="4" width="0"/><expanded_item id="0" parent="1"/><expanded_item id="1" parent="1"/><expanded_item id="2" parent="1"/><expanded_item id="3" parent="1"/></tab_structure><tab_browse><table title="movies" custom_title="0" dock_id="1" table="4,6:mainmovies"/><dock_state state="000000ff00000000fd00000001000000020000000000000000fc0100000001fb000000160064006f0063006b00420072006f00770073006500310100000000ffffffff0000011400ffffff000000000000000000000004000000040000000800000008fc00000000"/><default_encoding codec=""/><browse_table_settings/></tab_browse><tab_sql><sql name="SQL 1*">--1.一共有多少个用户、多少部电影、多少条评分?

 SELECT 'movies' AS table_name, COUNT(*) AS cnt
 FROM movies
 UNION ALL
 SELECT 'ratings' AS table_name, COUNT(*) AS cnt
 FROM ratings
 UNION ALL
 SELECT 'users' AS table_name, COUNT(*) AS cnt
 FROM users;



--2.评分最高的 10 部电影(只算评分次数 ≥ 50 的)

 SELECT movie_id,ROUND(AVG(rating),2) AS avg_rating,COUNT(*) AS count_num
 FROM ratings
 GROUP BY movie_id
 HAVING COUNT(*)&gt;=50
 ORDER BY avg_rating DESC
 LIMIT 10;



--3.平均分最高的 10 个电影类型

WITH RECURSIVE split_genre AS(
SELECT movie_id,
substr(genre,1,INSTR(genre || '|','|')-1) AS genre,
substr(genre,INSTR(genre || '|','|')+1) AS rest
FROM movies
WHERE genre IS NOT NULL AND genre!=''

UNION ALL

SELECT movie_id,
substr(rest,1,INSTR(rest || '|','|')-1) AS genre,
substr(rest,INSTR(rest || '|','|')+1) AS rest
FROM split_genre
WHERE rest!=''
),
movie_avg_rating AS(
SELECT movie_id,
ROUND(AVG(rating),2) AS avg_rating
FROM ratings
GROUP BY movie_id
HAVING COUNT(*)&gt;=20
)
SELECT mo.genre,
ROUND(AVG(ra.avg_rating),2) AS genre_avg_rating
FROM split_genre mo
LEFT JOIN movie_avg_rating ra
ON mo.movie_id=ra.movie_id
GROUP BY mo.genre
ORDER BY genre_avg_rating DESC
LIMIT 10;


--4.男用户和女用户的平均打分分别是多少?
SELECT us.gender, ROUND(AVG(ra.rating),2)
FROM users us JOIN ratings ra ON us.user_id=ra.user_id
GROUP BY us.gender;


--5.每个年龄段的用户数量,按人数降序

SELECT age,
count(*) AS nums
FROM users
GROUP BY age
ORDER BY nums DESC;



--6.打分次数最多的 10 个用户


SELECT user_id,
count(*) AS nums
FROM ratings
GROUP BY user_id
ORDER BY nums DESC
LIMIT 10;




--7.评分次数少于 20 次的用户有多少人?

SELECT count(*) AS us_nums
FROM (
SELECT user_id,
count(rating) AS ra_nums
FROM ratings
GROUP BY user_id
HAVING ra_nums&lt;20
) AS ra;



--8.1990 年之后上映的电影有多少部?


SELECT count(*) as mo_date_num
FROM(
SELECT movie_id
FROM movies
WHERE CAST(substr(title,length(title)-4,4)as INTEGER)&gt;1990
) AS mo;


--9.每个用户打分次数的平均值(不是电影平均分,是用户活跃度的平均)


SELECT round(avg(ra.ra_num),2) as mo_date_num
FROM(
SELECT user_id,
count(*) as ra_num
FROM ratings
GROUP by user_id
) AS ra;




--10.找出&quot;评分次数 ≥ 100 且平均分 ≥ 4.0&quot;的电影,按平均分降序取前 10


SELECT movie_id,
count(user_id) AS cnt,
round(avg(rating),2) AS avg_rating
FROM ratings
GROUP by movie_id
HAVING count(user_id)&gt;=100 AND round(avg(rating),2)&gt;=4.0
ORDER by avg(rating) DESC
LIMIT 10;





</sql><current_tab id="0"/></tab_sql></sqlb_project>
