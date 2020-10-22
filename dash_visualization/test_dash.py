




import pandas as pd
from dash.dependencies import Input, Output, State
import plotly.express as px
import plotly.graph_objects as go
import psycopg2
import os
import pathlib

#USER_NAME = os.environ['P_USER']
PASS = os.environ['P_PASS']
HOST = os.environ['P_HOST']
PORT = 5432

# Connection

try:
            connection = psycopg2.connect(
                user='student_salam',
                password=PASS,
                host=HOST,
                port=PORT,
                database='gp_makasa'
            )

            cursor = connection.cursor()


except Exception as e:
    print(e)

def data_from_fakta1():

    cursor.execute("""select sum(f.value_lovbrudd), l.lovbruddstype, å.år from star_schema.fakta_lovbrudd_1 f
join star_schema.dim_lovbruddstyper l using(lovbrudds_id) 
join star_schema.dim_år å using(år_id)
group by l.lovbruddstype, å.år
order by å.år asc;""")

    # Get one data from database
    data_df = cursor.fetchall()
    df_from_db = pd.DataFrame(data_df, columns=['value', 'lovbruddstype','år'])



    # connection.commit()
    # cursor.close()
    # connection.close()

    df_from_db.to_csv('fakta_lovbrudd_Norge.csv')

    return df_from_db

data_from_fakta1()