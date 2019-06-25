import pandas as pd
import numpy as np

df = pd.read_csv('original_dataset.csv', sep = ';')

df['roll1'] = pd.Series(180/np.pi*(np.arctan2(df['y1'], df['z1'])))
df['pitch1'] = pd.Series(180/np.pi*(np.arctan2(-df['x1'], np.sqrt(np.power(df['y1'], 2) + np.power(df['z1'], 2)))))
df['accel1'] = pd.Series(np.sqrt(np.power(df['x1'], 2) + np.power(df['y1'], 2) + np.power(df['z1'], 2)))

df['roll2'] = pd.Series(180/np.pi*(np.arctan2(df['y2'], df['z2'])))
df['pitch2'] = pd.Series(180/np.pi*(np.arctan2(-df['x2'], np.sqrt(np.power(df['y2'], 2) + np.power(df['z2'], 2)))))
df['accel2'] = pd.Series(np.sqrt(np.power(df['x2'], 2) + np.power(df['y2'], 2) + np.power(df['z2'], 2)))

df['roll3'] = pd.Series(180/np.pi*(np.arctan2(df['y3'], df['z3'])))
df['pitch3'] = pd.Series(180/np.pi*(np.arctan2(-df['x3'], np.sqrt(np.power(df['y3'], 2) + np.power(df['z3'], 2)))))
df['accel3'] = pd.Series(np.sqrt(np.power(df['x3'], 2) + np.power(df['y3'], 2) + np.power(df['z3'], 2)))

df['roll4'] = pd.Series(180/np.pi*(np.arctan2(df['y4'], df['z4'])))
df['pitch4'] = pd.Series(180/np.pi*(np.arctan2(-df['x4'], np.sqrt(np.power(df['y4'], 2) + np.power(df['z4'], 2)))))
df['accel4'] = pd.Series(np.sqrt(np.power(df['x4'], 2) + np.power(df['y4'], 2) + np.power(df['z4'], 2)))

df.to_csv('measure_dataset.csv', sep = ';', index=False)