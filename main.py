import sys
sys.path.append('SSBGetData/GetDataFromSSB.py')
sys.path.append('databaseconnection/addtodatabase.py')
# sys.path.append('dash_visualization/VisualizationLovbrudd.py')
from SSBGetData.GetDataFromSSB import main_program
from databaseconnection.addtodatabase import add_to_database, lovbrudd_08485, lovbrudd_09405, lovbrudd_09406, lovbrudd_09407, lovbrudd_09408, lovbrudd_09409, lovbrudd_09410, lovbrudd_09411, lovbrudd_09412, lovbrudd_09413, lovbrudd_11453
# from dash_visualization import VisualizationLovbrudd
import logging
from tabulate import tabulate


logging.basicConfig(filename='logging_file.log', level=logging.ERROR,
                    format='%(asctime)s | %(levelname)s | %(module)s | %(funcName)s: %(message)s')


class MainProgram:

    def __init__(self):
        pass

    def run_program(self):

        var_done = ''

        while var_done != 'done':

            self.option_list()

            user_choice = input('Enter your commend: ').lower()

            if user_choice == 'get data'.lower():
                main_program()
                print('DONE')
            elif user_choice == 'add to database':
                self.options_dataset()
                user_choice2 = input('Enter: ')
                if user_choice2 == 'all'.lower():
                    add_to_database()
                    print('All data are stored to the database')


                elif user_choice2 == '08485':
                    lovbrudd_08485()

                elif user_choice2 == '09405':
                    lovbrudd_09405()

                elif user_choice2 == '09406':
                    lovbrudd_09406()

                elif user_choice2 == '09407':
                    lovbrudd_09407()

                elif user_choice2 == '09408':
                    lovbrudd_09408()

                elif user_choice2 == '09409':
                    lovbrudd_09409()

                elif user_choice2 == '09410':
                    lovbrudd_09410()

                elif user_choice2 == '09411':
                    lovbrudd_09411()

                elif user_choice2 == '09412':
                    lovbrudd_09412()

                elif user_choice2 == '09413':
                    lovbrudd_09413()

                elif user_choice2 == '11453':
                    lovbrudd_11453()


            elif user_choice == 'dash':
                #
                pass


            elif user_choice == 'done'.lower():
                print('Program has closed!')
                break


    def option_list(self):
        # Options
        program_information = {'Get data from API to CSV files': 'get data',
                               'Add the data from API to DB': 'add to database',
                               'When done enter': 'Done'}
        instruction = program_information.items()


        headers = ['', 'OPTIONS']
        table = tabulate(instruction, headers, tablefmt="github")

        print("\u001b[33;1m")
        print(table)
        print("\u001b[37m")
        print()


    def options_dataset(self):
        # Options
        program_information = {'Get all data': 'all',
                               'lovbrudd data 08485': '08485',
                               'lovbrudd data 09405': '09405',
                               'lovbrudd data 09406': '09406',
                               'lovbrudd data 09407': '09407',
                               'lovbrudd data 09408': '09408',
                               'lovbrudd data 09409': '09409',
                               'lovbrudd data 09410': '09410',
                               'lovbrudd data 09411': '09411',
                               'lovbrudd data 09412': '09412',
                               'lovbrudd data 09413': '09413',
                               'lovbrudd data 11453': '11453',
                               'Exit': 'exit'}
        instruction = program_information.items()

        headers = ['Name of the dataset', 'OPTIONS']
        table = tabulate(instruction, headers, tablefmt="github")

        print("\u001b[33;1m")
        print(table)
        print("\u001b[37m")
        print()

mainprogram = MainProgram()
mainprogram.run_program()