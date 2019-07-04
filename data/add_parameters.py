import sys
import pandas as pd
import numpy as np

N_BINS = 10
FILE = sys.argv[1]
df = pd.read_csv(FILE, sep = ';')

if FILE == 'measure_dataset.csv':
	df = df.drop(labels = ['x1', 'y1', 'z1', 'x2', 'y2', 'z2', \
					'x3', 'y3', 'z3', 'x4', 'y4', 'z4'], axis = 1)

for class_action in df['class'].unique():
    df[class_action] = 0

for i in range(df.shape[0]):
    class_action = df.iloc[i]['class']
    if class_action == 'sitting':
        df.loc[i, 'sitting'] = 1
    elif class_action == 'sittingdown':
        df.loc[i, 'sittingdown'] = 1
    elif class_action == 'standing':
        df.loc[i, 'standing'] = 1
    elif class_action == 'standingup':
        df.loc[i, 'standingup'] = 1
    else:
        df.loc[i, 'walking'] = 1 

df['accel_mean'] = (df['accel1'] + df['accel2'] + \
                        df['accel3'] + df['accel4']) /4
accel_std = [np.std([df['accel1'].iloc[i], df['accel2'].iloc[i], \
                        df['accel3'].iloc[i], df['accel4'].iloc[i]]) for i in range(df.shape[0])]
df['accel_std'] = pd.Series(accel_std)

df.to_csv('continuous_dataset.csv', sep = ';', index=False)