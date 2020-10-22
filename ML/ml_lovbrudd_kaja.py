#Import lib
import os
import numpy as np
import pandas as pd
from sklearn.preprocessing import OneHotEncoder
from sklearn.model_selection import train_test_split


from sklearn.linear_model import LinearRegression

from sklearn.metrics import mean_absolute_error, mean_squared_error
from sklearn.metrics import accuracy_score
from sklearn.neighbors import KNeighborsRegressor





os.chdir(r'C:\Users\Kaja Amalie\Documents\Kaja\Graduation\data_preppet')
df = pd.read_csv('ml_lovbruddsfakta1.csv')

df_columns = df [['value', 'lovbruddstype', 'år', 'dato',
       'lag_1', 'lag_2', 'lag_3']]

df_colums2 = [['value', 'lovbruddstype', 'år', 'dato',
       'lag_1', 'lag_2', 'lag_3']]




#Lage overskrift til koloner fra OHE
dataprep = df_columns['lovbruddstype']
dataprep = dataprep.drop_duplicates()

lis = []
for i in dataprep:
    lis.append(i)



#1)Make lovbrudd into OneHotEncoder: 
lovbrudd_encoder = OneHotEncoder()
lovbrudd_encoder.fit(df_columns[['lovbruddstype']])
classes = lovbrudd_encoder.transform(df_columns[['lovbruddstype']]).todense()
classes_df = classes

df_encoder = pd.DataFrame(data = lis, index = None)

df_columns[lis] = pd.DataFrame(data=classes, index = None, columns = lis)

del df_columns['lovbruddstype']


df_train, df_test = train_test_split(df_columns, test_size=0.2, random_state = 420)

X_train = df_train
y_train = df_train['value']
del X_train['value']

X_test = df_test
y_test = df_test['value']
del X_test['value']


del X_test['dato']
del X_train['dato']

del X_test['år']
del X_train['år']


#%% ML models: 
    
    # Create and training model
lin_model = LinearRegression()
lin_model.fit(X=X_train, y=y_train)



#Make prediction 
y_pred_train = lin_model.predict(X_train )
mean_absolute_error(y_train, y_pred_train) #4690.180172227516  #3483.9422161470848
np.sqrt(mean_squared_error(y_train, y_pred_train)) #16097.445066695174 # 16300.832659133444


y_pred_test = lin_model.predict(X_test)
mean_absolute_error(y_test, y_pred_test) #5010.878680866251 #3736.0891936734934
np.sqrt(mean_squared_error(y_test, y_pred_test)) #17045.78794448737 #17186.60185297543




#%%

X_2019 = X








#%%

from sklearn.metrics import r2_score

def rmse_mae_and_r2(model,x,y, y_pred):
    rmse = (np.sqrt(mean_squared_error(y, y_pred)))
    r2 = r2_score(y, y_pred)
    ame = mean_absolute_error(y, y_pred)
    print("The model performance")
    print("--------------------------------------")
    print('RMSE is {}'.format(rmse))
    print('MAE is {}'.format(ame))
    print('R2 score is {} '.format(r2))
    print("\n")
  
  
  rmse_mae_and_r2(lin_model,X_test, y_test, y_pred_test)
  
# RMSE is 17045.78794448737
# MAE is 5010.878680866251
# R2 score is 0.9645779925502898 

#RMSE is 17186.60185297543
#MAE is 3736.0891936734934
#R2 score is 0.9639903384386 
  

#%%

df_pred = pd.DataFrame(data = y_pred_test, index = None, columns = ['value_pred'])
df_pred['val_act'] = np.c_[y_test]
df_pred['lovbrudd'] = np.c_[X_test['lovbruddstype']]
df_pred['år'] = np.c_[X_test['år']]

df_pred.to_csv('pred_vs_actual.csv', index = False)

#%%


df_pred['value_act'] = pd.DataFrame(data = y_test, index = None, columns = ['value_act'])


