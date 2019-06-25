import pandas as pd
import numpy as np

N_BINS = 10
FIELDS = ['pitch1', 'pitch2', 'pitch3', 'pitch4', 'roll1', 'roll2', 'roll3', 'roll4', \
              'accel1', 'accel2', 'accel3', 'accel4', 'accel_mean', 'accel_std']
df = pd.read_csv('continuous_dataset.csv', sep = ';')

for field in FIELDS:
    df[f'{field}_disc'] = pd.Series(pd.cut(df[field], N_BINS, \
                                              labels=list(range(N_BINS))))

df.to_csv('discrete_dataset.csv', sep = ';', index=False)