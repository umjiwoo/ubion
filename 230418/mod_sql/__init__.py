import pymysql
import pandas as pd

class Database:
    def __init__(self,_host,_user,_pass,_db,_port):
        self.db = pymysql.connect(
            user = _user,
            password = _pass,
            host = _host,
            db = _db,
            port = _port)

        self.cursor = self.db.cursor(pymysql.cursors.DictCursor)


    def sql_query(self,sql,values=[]):
        if (sql.replace('\n','').strip().startswith('select') or sql.replace('\n','').strip().startswith('SELECT')):
            self.cursor.execute(sql,values)
            result = self.cursor.fetchall()
            result = pd.DataFrame(result)
        else:
            self.cursor.execute(sql,values)
            self.db.commit()
            result="Query OK"

        return result

    def sql_close(self):
        self.db.close()            