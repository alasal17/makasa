from SSBGetData.GetDataFromSSB import *

def run_program():

    var_done = ''

    while var_done != 'done' :
        user_choice = input('\nEnter your commend: ').lower()

        if user_choice == 'Get data'.lower():
            main_program()
        elif user_choice == 'done'.lower():
            print('Program has closed!')
            break



run_program()