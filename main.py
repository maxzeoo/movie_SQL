
import sqlite3

batch_size=1000

#用户数据清洗#
def clean_user_row(row):
    user_id = int(row[0])
    gender = row[1].strip()
    age = int(row[2])
    occupation = int(row[3])
    zip_code = row[4].strip()
    return (user_id, gender, age, occupation, zip_code)

#电影数据清洗#
def clean_movie_row(row):
    movie_id = int(row[0])
    title = row[1].strip()
    genre = "|".join(g.strip() for g in row[2].split("|"))
    return (movie_id, title, genre)

#评分数据清理#
def clean_rating_row(row):
    user_id = int(row[0])
    movie_id = int(row[1])
    rating = int(row[2])
    timestamp = int(row[3])
    return (user_id, movie_id, rating, timestamp)

def make_db():
    with sqlite3.connect(r'C:\Users\lx\Desktop\职业规划\sql\movie.db') as conn:
        cursors=conn.cursor()
        cursors.execute("PRAGMA foreign_keys = ON;")

        #先删除表格#
        cursors.execute("DROP TABLE IF EXISTS ratings;")
        cursors.execute("DROP TABLE IF EXISTS movies;")
        cursors.execute("DROP TABLE IF EXISTS users;")

        cursors.execute('''CREATE TABLE users(
        user_id  INTEGER PRIMARY KEY,
        gender  TEXT,
        age  INTEGER,
        occupation  INTEGER,
        zip_code    TEXT
        )''')
        cursors.execute('''CREATE TABLE  movies(
        movie_id  INTEGER PRIMARY KEY,
        title  TEXT,
        genre  TEXT
        )''')
        cursors.execute('''CREATE TABLE ratings(
        user_id  INTEGER NOT NULL,
        movie_id  INTEGER NOT NULL,
        rating  INTEGER NOT NULL,
        timestamp  INTEGER,
        PRIMARY KEY (user_id, movie_id),
        FOREIGN KEY(user_id) REFERENCES users(user_id),
        FOREIGN KEY(movie_id) REFERENCES movies(movie_id)
        )''')

        #插入用户数据#
        with open(r'C:\Users\lx\Desktop\职业规划\电影算法推荐\ml-1m\ml-1m\users.dat','r',newline="",encoding="Latin-1") as f:
            batch=[]
            count=0
            for line_no,row in enumerate(f,1):
                #清洗异常捕获#
                row=row.strip()
                if not row:
                    continue
                row=row.split('::')
                try:
                    batch.append(clean_user_row(row))
                except (ValueError, IndexError) as e:
                    print(f'users.dat第{line_no}行跳过：{e}')
                    continue
                #插入异常捕获#
                if len(batch) >= batch_size:
                    try:
                        cursors.executemany(
                            "INSERT INTO users(user_id,gender,age,occupation,zip_code) VALUES (?,?,?,?,?)",
                            batch
                        )
                    except (sqlite3.IntegrityError):
                        count+=1
                    batch=[]
            if batch:
                try:
                    cursors.executemany(
                        "INSERT INTO users(user_id,gender,age,occupation,zip_code) VALUES (?,?,?,?,?)",
                        batch
                    )
                except (sqlite3.IntegrityError):
                    count += 1
            if count>0:
                print(f'users.dat主键存在重复或者不存在')


        #插入电影数据#
        with open(r'C:\Users\lx\Desktop\职业规划\电影算法推荐\ml-1m\ml-1m\movies.dat',"r",newline="",encoding="Latin-1") as f:
            batch=[]
            count=0
            for line_no, row in enumerate(f, 1):
                # 清洗异常捕获#
                row = row.strip()
                if not row:
                    continue
                row = row.split('::')
                try:
                    batch.append(clean_movie_row(row))
                except (ValueError, IndexError) as e:
                    print(f'movies.dat第{line_no}行跳过：{e}')
                    continue

                if len(batch) >= batch_size:
                   try:
                        cursors.executemany(
                            "INSERT INTO movies(movie_id,title,genre) VALUES (?,?,?)",
                            batch
                        )
                   except sqlite3.IntegrityError:
                        count+=1
                   batch=[]

            if batch:
                try:
                    cursors.executemany(
                        "INSERT INTO movies(movie_id,title,genre) VALUES (?,?,?)",
                        batch
                    )
                except (sqlite3.IntegrityError):
                    count += 1
            if count>0:
                print(f'movies.dat主键存在重复或者不存在')



        #插入评分数据#
        with open(r'C:\Users\lx\Desktop\职业规划\电影算法推荐\ml-1m\ml-1m\ratings.dat',"r",newline="",encoding="Latin-1") as f:
            batch=[]
            count=0
            for line_no, row in enumerate(f, 1):
                # 清洗异常捕获#
                row = row.strip()
                if not row:
                    continue
                row = row.split('::')
                try:
                    batch.append(clean_rating_row(row))
                except (ValueError, IndexError) as e:
                    print(f'ratings.dat第{line_no}行跳过：{e}')
                    continue

                if len(batch) >= batch_size:
                    try:
                        cursors.executemany(
                            "INSERT INTO ratings(user_id,movie_id,rating,timestamp) VALUES (?,?,?,?)",
                            batch
                        )
                    except (sqlite3.IntegrityError):
                        count+=1
                    batch=[]

            if batch:
                try:
                    cursors.executemany(
                        "INSERT INTO ratings(user_id,movie_id,rating,timestamp) VALUES (?,?,?,?)",
                        batch
                    )
                except (sqlite3.IntegrityError):
                    count+=1
            if count>0 :
                print(f'ratings.dat主键存在重复或者不存在')





if __name__ == '__main__':
    make_db()