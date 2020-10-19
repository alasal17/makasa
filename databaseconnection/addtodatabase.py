
from sqlalchemy import create_engine
import os
import pandas as pd

USER = 'student_salam'
PASS = os.environ['P_PASS']
HOST = os.environ['P_HOST']
DATABASE = 'gp_makasa'
PORT = 5432

def add_to_database():
    lovbrudd_08485()
    lovbrudd_09405()
    lovbrudd_09406()
    lovbrudd_09407()
    lovbrudd_09408()
    lovbrudd_09409()
    lovbrudd_09410()
    lovbrudd_09411()
    lovbrudd_09412()
    lovbrudd_09413()
    lovbrudd_11453()


def connect_to_database(table_name, data_df):

    engine = create_engine(f'postgresql://{USER}:{PASS}@{HOST}/{DATABASE}')

    #engine = create_engine(f'postgresql://user:pass@0.0.0.0:35432/db')
    data_df.to_sql(name=table_name, con=engine, if_exists='replace')




def lovbrudd_08485():
    df = pd.read_csv(r'./SSBGetData/dataset/lovbrudd_08485.csv')
    connect_to_database('lovbrudd_08485', df)
    print("\033[0;32m", 'Done ')
    print("\u001b[35m", 'lovbrudd_08485 added to database')
    
def lovbrudd_09405():
    df = pd.read_csv('./SSBGetData/dataset/lovbrudd_09405.csv')
    connect_to_database('lovbrudd_09405', df)
    print("\033[0;32m", 'Done ')
    print("\u001b[35m", 'lovbrudd_09405 added to database')

def lovbrudd_09406():
    df = pd.read_csv('./SSBGetData/dataset/lovbrudd_09406.csv')
    connect_to_database('lovbrudd_09406', df)
    print("\033[0;32m", 'Done ')
    print("\u001b[35m", 'lovbrudd_09406 added to database')
    
def lovbrudd_09407():
    df = pd.read_csv('./SSBGetData/dataset/lovbrudd_09407.csv')
    connect_to_database('lovbrudd_09407', df)
    print("\033[0;32m", 'Done ')
    print("\u001b[35m", 'lovbrudd_09407 added to database')
     
def lovbrudd_09408():
    df = pd.read_csv('./SSBGetData/dataset/lovbrudd_09408.csv')
    connect_to_database('lovbrudd_09408', df)
    print("\033[0;32m", 'Done ')
    print("\u001b[35m", 'lovbrudd_09408 added to database')
    
def lovbrudd_09409():
    df = pd.read_csv('./SSBGetData/dataset/lovbrudd_09409.csv')
    connect_to_database('lovbrudd_09409', df)
    print("\033[0;32m", 'Done ')
    print("\u001b[35m", 'lovbrudd_09409 added to databaseconnection')

def lovbrudd_09410():
    df = pd.read_csv('./SSBGetData/dataset/lovbrudd_09410.csv')
    connect_to_database('lovbrudd_09410', df)
    print("\033[0;32m", 'Done ')
    print("\u001b[35m", 'lovbrudd_09410 added to databaseconnection')

def lovbrudd_09411():
    df = pd.read_csv('./SSBGetData/dataset/lovbrudd_09411.csv')
    connect_to_database('lovbrudd_09411', df)
    print("\033[0;32m", 'Done ')
    print("\u001b[35m", 'lovbrudd_09411 added to database')
    
def lovbrudd_09412():
    df = pd.read_csv('./SSBGetData/dataset/lovbrudd_09412.csv')
    connect_to_database('lovbrudd_09412', df)
    print("\033[0;32m", 'Done ')
    print("\u001b[35m", 'lovbrudd_09412 added to database')

def lovbrudd_09413():
    df = pd.read_csv('./SSBGetData/dataset/lovbrudd_09413.csv')
    connect_to_database('lovbrudd_09413', df)
    print("\033[0;32m", 'Done ')
    print("\u001b[35m", 'lovbrudd_09413 added to database')
    
def lovbrudd_11453():
    df = pd.read_csv('./SSBGetData/dataset/lovbrudd_11453.csv')
    connect_to_database('lovbrudd_11453', df)
    print("\033[0;32m", 'Done ')
    print("\u001b[35m", 'lovbrudd_11453 added to database')