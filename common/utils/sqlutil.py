
from django.db import connection, transaction

def fetchQuery(query, params={}):
    
    with connection.cursor() as cursor:
        try:
            cursor.execute(query, params)
            row = cursor.fetchall()
        finally:
           
            transaction.commit()
            cursor.close()
    return row
            
def getColumns(query, params=[]):
     
    with connection.cursor() as cursor:
        try:
            cursor.execute(query, params)
            field_names = [i[0] for i in cursor.description]
        finally:
           
            transaction.commit()
            cursor.close()
            
    return field_names

def executeQuery(query, params=[]):
    with connection.cursor() as cursor:
        try:
            cursor.execute(query, params)
        finally:
                     
            transaction.commit()
            cursor.close()
