import pandas as pd

df = pd.read_csv('discrete_dataset.csv', sep = ';')

train_df = pd.DataFrame()
for class_action in df['class'].unique():
    class_df = df.loc[df['class'] == class_action]
    n_instance = class_df.shape[0]
    train_df = train_df.append(class_df.sample(n = int(0.8 * n_instance), replace = False))

test_df = pd.concat([df, train_df]).drop_duplicates(keep=False)

train_df.to_csv('train_dataset.csv', sep = ';', index=False)
test_df.to_csv('test_dataset.csv', sep = ';', index=False)