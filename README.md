# MovieLens SQL 数据分析项目

> 
> 基于电影推荐项目数据集，使用 SQLite 完成多维度数据分析，包含建库脚本、10 道 SQL 笔试真题查询。适合测试开发 / 数据分析 SQL 笔试复习练习。

##  项目介绍

本项目通过 Python 读取原始 Movie 数据集，自动生成 SQLite 数据库文件 `movie.db`；
`queries.sql` 内包含 10 个业务分析 SQL，覆盖**多表关联、字符串拆分（递归 CTE）、分组聚合、子查询、留存、排序过滤**等笔试高频考点。

适合用途：

- SQL 笔试刷题练习（测试开发、数据分析岗）
- SQLite 递归 CTE 拆分分隔字符串实战案例
- 学习 GROUP BY、HAVING、LEFT JOIN、子查询、WITH CTE 等核心语法

###  项目目录结构

```
.
├── main.py                # Python脚本：读取原始数据，生成movie.db数据库
├── movie.db               # SQLite数据库文件（生成产物，可本地直接打开）
├── queries.sql            # 10条分析SQL，对应10个业务分析题目
├── raw_data/              # 原始MovieLens数据集文件夹（csv数据）
└── README.md              # 项目说明文档
```

##  环境依赖

- Python >=3.8
- 内置 sqlite3（Python 自带，无需额外安装）
- 可选工具：DB Browser for SQLite（可视化打开 db 文件）

##  快速运行步骤

1. 克隆项目到本地

```
git clone https://github.com/maxzeoo/movie_SQL.git
cd movie-sql-analysis
```

2. 准备原始数据集，放入`raw_data`文件夹
3. 运行 Python 脚本，自动生成数据库

```
python main.py
```

执行完成后，目录会生成 `movie.db` 文件。

4. 执行 SQL 查询

> 
> 方式 1：使用 DB Browser for SQLite 打开 movie.db，复制`queries.sql`中单条 SQL 执行
> 方式 2：sqlite 命令行

```
sqlite3 movie.db
.read queries.sql
```

> 
> 注意：`queries.sql`包含多条 SELECT 语句，一次性执行只会输出最后一条结果。建议一次复制一题单独执行。

##  queries.sql 题目清单

> 
> 10 道 SQL 练习题（测试开发笔试高频题型）

1. 统计：总用户数、电影总数、总评分记录数
2. 评分最高的 10 部电影（仅统计评分次数≥50 的电影）
3. 平均分最高的 10 个电影类型（递归 CTE 拆分 | 分隔的多类型标签）
4. 男、女用户各自的平均打分
5. 各年龄段用户数量，按人数降序
6. 打分次数最多的 10 个用户
7. 打分次数少于 20 次的用户总人数
8. 1990 年之后上映的电影数量
9. 用户平均打分次数（用户活跃度均值）
10. 筛选评分≥100 条且平均分≥4.0 的电影，取前 10，按平均分降序

##  核心知识点（笔试重点）

1. `GROUP BY` + `HAVING`：分组后聚合过滤（区分 WHERE 与 HAVING）
2. `JOIN / LEFT JOIN` 多表关联
3. 递归 CTE（`WITH RECURSIVE`）：拆分`|`分隔字符串，一行拆多行
4. 子查询、嵌套查询
5. `SUBSTR / INSTR / CAST` 字符串提取、类型转换（提取电影年份）
6. `UNION ALL` 纵向合并结果集
7. `ROUND / AVG / COUNT` 聚合函数，`LIMIT`分页排序

##  注意事项

1. 一次性执行全部 SQL 脚本只会返回最后一题结果，**推荐单题独立运行**
2. 数据库文件`movie.db`是 Python 脚本生成产物，不需要手动写建表语句
3. 年份提取采用字符串截取方案，提供两种想法（固定末尾截取 / 括号内提取），后者鲁棒性更强，但本文由于数据集来源可靠稳定仅靠固定结尾截取。
4. 递归 CTE 为 SQLite 语法，MySQL8.0 + 也支持；低版本数据库不支持递归 CTE
5. 在查询20条评论以下时为0，是基于数据集特性，保证每个用户至少有 20 条评分。

## 优化方向

1. main.py代码指定了数据集来源地址，未做相对路径优化。
2. 批量插入时插入失败仅为单个表格出错提示一次，具体代码仅精确到1000条内，可在出现报错时回退，找出坏行，本代码尚未完善。