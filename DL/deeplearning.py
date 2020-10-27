from tensorflow.keras.layers import Dense, Input, Conv2D, MaxPooling2D, Flatten, BatchNormalization, LSTM, SimpleRNN, Embedding, Dropout
from tensorflow.keras.models import Model, Sequential
from tensorflow.keras.losses import SparseCategoricalCrossentropy
import tensorflow as tf

from sklearn.metrics import accuracy_score
from sklearn.model_selection import train_test_split
from sklearn.datasets import fetch_openml
from sklearn.preprocessing import OneHotEncoder,  MinMaxScaler, StandardScaler
import tensorflow as tf
from sklearn.linear_model import LogisticRegression

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
tf.keras.backend.clear_session()

df = pd.read_csv('')


def create_dataset(X, y, date_steps=1):
    Xs, ys = [], []
    for i in range(len(X) - date_steps):
        v = X.iloc[i:(i + date_steps)].values
        Xs.append(v)
        ys.append(y.iloc[i + date_steps])
    return np.array(Xs), np.array(ys)


date_steps = 25


def run_model():

    X_df_all = df.loc[:, df.columns != 'value']
    y_df_all = df['value']
    X_train_, y_train_ = create_dataset(X_df_all, y_df_all, date_steps)

    X_input = Input(shape=(25, 375))
    LSTM_layer = LSTM(128)(X_input)
    dense1 = Dense(100)(LSTM_layer)
    dense2 = Dense(50)(dense1)
    output = Dense(1)(dense2)

    model = Model(inputs=[X_input], outputs=output)

    model.compile(optimizer='adam', loss='mse', metrics=['mae'])
    model_checkpoint = tf.keras.callbacks.ModelCheckpoint('best_score', monitor='val_accuracy', mode='max', save_best_only=True)

    history = model.fit(X_train_, y_train_, epochs=34, validation_split=0.2, callbacks=[model_checkpoint])

    plt.figure(figsize=(20, 10))
    plt.plot(history.history['loss'], label='loss')
    # plt.plot(history.history['val_loss'], label = 'val_loss')
    plt.xlabel('Epoch')
    plt.ylabel('loss')
    plt.legend(loc='lower right')

    plt.figure(figsize=(20, 10))
    plt.plot(history.history['val_loss'], label='val_loss')
    plt.xlabel('Epoch')
    plt.ylabel('val_loss')
    plt.legend(loc='lower right')

    plt.show()


