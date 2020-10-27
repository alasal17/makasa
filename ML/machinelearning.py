import pandas as pd
from sklearn.tree import DecisionTreeClassifier # Import Decision Tree Classifier
from sklearn.model_selection import train_test_split # Import train_test_split function
from sklearn import metrics #Import scikit-learn metrics module for accuracy calculation
import numpy as np
from sklearn.preprocessing import OneHotEncoder
from sklearn.metrics import mean_absolute_error, mean_squared_error
from sklearn.metrics import r2_score
from sklearn.linear_model import LinearRegression, LogisticRegression
import matplotlib.pyplot as plt
import xgboost as xgb

def get_the_data():
    data = pd.read_csv('/content/fakta_lovbrudd_Norge.csv')
    del data['Unnamed: 0']
    df_copy = data.copy()
    df_copy['dato'] = pd.to_datetime(df_copy['år'], format='%Y', )
    df_copy = df_copy.fillna(0)


    return df_copy

def _onehotencoder():

    df_copy = get_the_data()

    y_2d = np.array(df_copy['lovbruddstype']).reshape(-1, 1)
    class_ohe = OneHotEncoder(sparse=False)
    class_ohe.fit(y_2d)
    ohe_lovbrudd = class_ohe.transform(y_2d)

    header_list = class_ohe.categories_
    ohe_lovbrudd_df = pd.DataFrame(ohe_lovbrudd, columns=header_list)
    ohe_lovbrudd_df = ohe_lovbrudd_df.reset_index()

    full_df_col = [col[0][1:] if i != 0 else col[0] for i, col in enumerate(ohe_lovbrudd_df.columns)] + ['value','lovbruddstype','år', 'dato']
    full_df = pd.concat([ohe_lovbrudd_df, df_copy[['value', 'lovbruddstype', 'år', 'dato']]], axis=1, join='outer')
    full_df.columns = full_df_col

    del full_df['index']
    del full_df['lovbruddstype']
    del full_df['år']

    full_df.to_csv('full_dataset_lovbrudd_Norge.csv', encoding='utf-8', sep=',', index=False)

    return full_df

def run_models():

    full_df = _onehotencoder()

    X_df = full_df.loc[:, full_df.columns != 'value']
    X_df = full_df.loc[:, full_df.columns != 'lovbruddstype']
    X_df = full_df.loc[:, full_df.columns != 'år']

    y_df = full_df['value']

    X_train, X_test, y_train, y_test = train_test_split(X_df, y_df, test_size=0.2, random_state=420)

    X_train = np.c_[X_train]
    X_test = np.c_[X_test]

    y_train = np.c_[y_train]
    y_test = np.c_[y_test]

    clf = DecisionTreeClassifier()
    clf = clf.fit(X_train, y_train)
    y_pred_clf = clf.predict(X_test)


# DecisionTreeClassifier
    print('DecisionTreeClassifier')
    rmse_mae_and_r2(clf, X_test, y_test, y_pred_clf)
    print('\n')
# LinearRegression
    lr_mode = LinearRegression()
    lr_mode.fit(X_train, y_train)

    y_preds_lr = lr_mode.predict(X_test)
    print('LinearRegression')
    rmse_mae_and_r2(model=lr_mode, x=X_test, y=y_test, y_pred=y_preds_lr)
    print('\n')

# XGBRegressor
    xgb_model = xgb.XGBRegressor(objective="reg:linear", random_state=42)
    xgb_model.fit(X_train, y_train)
    y_pred_xg = xgb_model.predict(X_test)

    print('XGBRegressor')
    rmse_mae_and_r2(model=xgb_model, x=X_test, y=y_test, y_pred=y_pred_xg)
    print('\n')

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

