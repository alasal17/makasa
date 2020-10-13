import sys
sys.path.append('SSBGetData/GetDataFromSSB.py')
sys.path.append('databaseconnection/addtodatabase.py')
from SSBGetData.GetDataFromSSB import main_program
from databaseconnection.addtodatabase import add_to_database, lovbrudd_09405, lovbrudd_09406
import logging

logging.basicConfig(filename='logging_file.log', level=logging.ERROR,
                    format='%(asctime)s | %(levelname)s | %(module)s | %(funcName)s: %(message)s')
def run_program():

    var_done = ''

    while var_done != 'done':

        user_choice = input('Enter your commend: ').lower()

        if user_choice == 'Get data'.lower():
            main_program()
            print('DONE')
        elif user_choice == 'add to database':
            user_choice2 = input('Enter: ')
            if user_choice2 == 'all'.lower():
                add_to_database()
                print('All data are stored to the database')

            elif user_choice2 == '09405':
                lovbrudd_09405()

        elif user_choice == 'done'.lower():
            print('Program has closed!')
            break



run_program()