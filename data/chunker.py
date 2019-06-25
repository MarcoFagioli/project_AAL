import pandas as pd
import numpy as np

def make_mean_variance(dataframe):
    new_row = {}
    
    for field in ['user', 'gender', 'age', 'how_tall_in_meters', 'weight', 'body_mass_index', 'class']:
        new_row[field] = dataframe[field].iloc[0]
    
    for field in ['roll1', 'pitch1', 'roll2', 'pitch2', 'roll3', 'pitch3','roll4', 'pitch4']:
        new_row[field] = np.var(dataframe[field])
        
    for i in range (1, 5):
        x_list = dataframe[f'x{i}']
        y_list = dataframe[f'y{i}']
        z_list = dataframe[f'z{i}']
        x = x_list.sum()
        y = y_list.sum()
        z = z_list.sum()

        new_row[str(f'accel{i}')] = np.sqrt(np.power(x, 2) + np.power(y, 2) + np.power(z, 2))/x_list.shape[0]
    
    return new_row

df = pd.read_csv('measure_dataset.csv', sep = ';')
avg_df = pd.DataFrame()

for class_action in df['class'].unique():
    class_df = df.loc[df['class'] == class_action]
    
    for user in class_df['user'].unique():
        class_user_df = class_df.loc[class_df['user'] == user]
        n_instance = class_user_df.shape[0]
        
        for i in range(int(np.ceil(n_instance/7))):
            avg_df = avg_df.append(make_mean_variance(class_user_df[i*7:min((i+1)*7+1, n_instance)]), ignore_index=True)

avg_df.to_csv('row_dataset.csv', sep = ';', index=False)