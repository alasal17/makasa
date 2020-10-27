#Import lib
import os
import numpy as np
import pandas as pd
from sklearn.preprocessing import OneHotEncoder
from sklearn.model_selection import train_test_split

from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_absolute_error, mean_squared_error



#%%
#Data prep (på det salam allerede har gjort)


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
X_test_til_pred = X_test
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

#uten år: 
#RMSE is 17186.60185297543
#MAE is 3736.0891936734934
#R2 score is 0.9639903384386 
df_2018 = df[df['år'] == 2018]
df = df.sort_values(['lovbruddstype', 'år'])
df['leg1'] = df['value'].shift(1)

#%% lage CSV med både orginal value og predikert value (for å kunne sammenligne de i PowerBI)

df_pred = pd.DataFrame(data = y_pred_test, index = None, columns = ['value_pred'])
df_pred['val_act'] = np.c_[y_test]
df_pred['lovbrudd'] = np.c_[X_test_til_pred['lovbruddstype']]
df_pred['år'] = np.c_[X_test['år']]

df_pred.to_csv('pred_vs_actual.csv', index = False)

#%%


## Prøve å predikere 2019: 
    

df = pd.read_csv('ml_lovbruddsfakta1.csv')
df.fillna(0)


dataprep = df['lovbruddstype']
dataprep = dataprep.drop_duplicates()

lis = []
for i in dataprep:
    lis.append(i)

lovbrudd_encoder = OneHotEncoder()
lovbrudd_encoder.fit(df[['lovbruddstype']])
classes = lovbrudd_encoder.transform(df[['lovbruddstype']]).todense()
classes_df = pd.DataFrame(data=classes, index = None, columns = lis)


df[lis] = pd.DataFrame(data=classes, index = None, columns = lis)



#Til å predikere (år 2018):
df_2018 = df.where(df['år']== 2018)
df_2018 = df_2018.dropna()

df_2018 = df_2018.sort_values(['lovbruddstype', 'år'])
df_2019 = df_2018

df_2019['value i %'] = df_2018['value'].pct_change()
df_2019['lag_1'] = df_2019['value i %'].shift(1)
df_2019['lag_2'] = df_2019['lag_1'].shift(2)
df_2019['lag_3'] = df_2019['lag_2'].shift(3)


del df_2019['år']
del df_2019['dato']
del df_2019['% endring fra året før']
del df_2019['value i %']
del df_2019['value']
del df_2019['lovbruddstype']
df_2019 = df_2019.fillna(0)
df_2019 = df_2019.reset_index(drop = True)


df_2019[lis] = classes_df


#%%

#Make prediction 
pred_2019 = lin_model.predict(df_2019)



df = pd.read_csv('ml_lovbruddsfakta1.csv')
df.fillna(0)
df_2018 = df.where(df['år']== 2018)
df_2018 = df_2018.dropna()

df_2018 = df_2018.sort_values(['lovbruddstype', 'år'])
df_2019 = df_2018

df_2019['år'] = 2019
del df_2019['lag_1']
del df_2019['lag_2']
del df_2019['lag_3']
del df_2019['value']
df_2019['pred_values'] = pred_2019

df_2019.to_csv('pred_2019.csv', index = False)



