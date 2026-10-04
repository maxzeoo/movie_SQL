--1.一共有多少个用户、多少部电影、多少条评分?
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
 HAVING COUNT(*)>=50
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
HAVING COUNT(*)>=20
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
HAVING ra_nums<20
) AS ra;

--8.1990 年之后上映的电影有多少部?
SELECT count(*) as mo_date_num
FROM(
SELECT movie_id
FROM movies
WHERE CAST(substr(title,length(title)-4,4)as INTEGER)>1990
) AS mo;

--9.每个用户打分次数的平均值(不是电影平均分,是用户活跃度的平均)
SELECT round(avg(ra.ra_num),2) as mo_date_num
FROM(
SELECT user_id,
count(*) as ra_num
FROM ratings
GROUP by user_id
) AS ra;

--10.找出"评分次数 ≥ 100 且平均分 ≥ 4.0"的电影,按平均分降序取前 10
SELECT movie_id,
count(user_id) AS cnt,
round(avg(rating),2) AS avg_rating
FROM ratings
GROUP by movie_id
HAVING count(user_id)>=100 AND avg(rating)>=4.0
ORDER by avg(rating) DESC
LIMIT 10;
