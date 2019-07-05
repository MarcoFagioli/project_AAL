import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import itertools

def plot_confusion_matrix(cm, model, classes,
                          normalize=False,
                          title='Confusion matrix',
                          cmap=plt.cm.Reds):
    
    string_normalized = 'not-normalized'
    if normalize:
        cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
        string_normalized = 'normalized'

    plt.figure()
    plt.imshow(cm, interpolation='nearest', cmap=cmap)
    plt.title(title)
    plt.colorbar()
    tick_marks = np.arange(len(classes))
    plt.xticks(tick_marks, classes, rotation=45)
    plt.yticks(tick_marks, classes)

    fmt = '.2f' if normalize else 'd'
    thresh = cm.max() / 2.
    for i, j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
        plt.text(j, i, format(cm[i, j], fmt),
                 horizontalalignment="center",
                 color="white" if cm[i, j] > thresh else "black")

    plt.tight_layout()
    plt.xlabel('True label')
    plt.ylabel('Predicted label')
    plt.savefig(f'confusion_matrix_{model}_{string_normalized}.png', dpi = 180)
    plt.show()


df = pd.read_csv('confusion_matrix.csv', sep = ',')
confusion_matrix = df.values
classes = list(df)

plot_confusion_matrix(
            confusion_matrix,
            'naive',
            classes,
            normalize=False
        )