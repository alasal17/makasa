import psycopg2
import os
import dash
import dash_core_components as dcc
import dash_html_components as html
import pandas as pd
from dash.dependencies import Input, Output
import plotly.express as px
import plotly.graph_objects as go
import psycopg2
import os

#
# USER_NAME = os.environ['P_USER']
# PASS = os.environ['P_PASS']
# HOST = os.environ['P_HOST']
# PORT = 5432
# def data_from_database():
#
#     # Connection
#     try:
#         connection = psycopg2.connect(
#             user=USER_NAME,
#             password=PASS,
#             host=HOST,
#             port=PORT,
#             database='gp_makasa'
#         )
#
#         cursor = connection.cursor()
#
#
#         cursor.execute('Select kjønn, alder, value from lovbruddsdata.lovbrudd_11453;')
#
#     # Get one data from database
#         data_df = cursor.fetchall()
#
#         df_from_db = pd.DataFrame(data_df, columns=['kjønn', 'alder', 'value'])
#
#     # Get all data from database
#         #data_df = cursor.fetchall()
#         connection.commit()
#
#         cursor.close()
#         connection.close()
#
#     except Exception as e:
#         print(e)
#
#     return df_from_db
#
# daf = data_from_database()
# daf

df = pd.read_csv('../SSBGetData/dataset/lovbrudd_09405.csv')
df = df[df['value'] != 0.0]

df.to_csv('../SSBGetData/dataset/lovbrudd_09405.csv', index=False)

df_sub = df
years = 2004
df_sub = df_sub[df_sub['år'] == years]
import json
from urllib.request import urlopen
with urlopen('https://raw.githubusercontent.com/plotly/datasets/master/geojson-counties-fips.json') as response:
    counties = json.load(response)

oslo_df = pd.read_csv("https://raw.githubusercontent.com/plotly/datasets/master/fips-unemp-16.csv")
print(oslo_df)