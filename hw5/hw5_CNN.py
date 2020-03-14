# Import important packages
import numpy as np
import tensorflow as tf
import matplotlib.pyplot as plt
import pandas as pd
from sklearn.metrics import confusion_matrix

# Load fashion data
fashion_mnist = tf.keras.datasets.fashion_mnist
(X_train_full, y_train_full), (X_test, y_test) = \
    fashion_mnist.load_data()

# Separate data into training and validation
X_valid = X_train_full[:5000] / 255.0
X_train = X_train_full[5000:] / 255.0
X_test = X_test / 255.0

y_valid = y_train_full[:5000]
y_train = y_train_full[5000:]

# Add third dimension
X_train = X_train[..., np.newaxis]
X_valid = X_valid[..., np.newaxis]
X_test = X_test[..., np.newaxis]

from functools import partial

# Creates baseline dense and convolutional layer
my_dense_layer = partial(tf.keras.layers.Dense, activation="relu",
                         kernel_regularizer=tf.keras.regularizers.l2(0.0001))
my_conv_layer = partial(tf.keras.layers.Conv2D,
                        activation="relu", padding="valid")

# Creates all layers
model = tf.keras.models.Sequential([
    my_conv_layer(6,4,padding="same",input_shape=[28,28,1]),
    my_conv_layer(32,3),
    tf.keras.layers.MaxPooling2D(2),
    tf.keras.layers.Dropout(0.3),
    tf.keras.layers.Flatten(),
    my_dense_layer(128),
    my_dense_layer(10, activation="softmax")
])

# Gives dimensions of model
model.summary()

# Adds opimizer to neural network
model.compile(loss="sparse_categorical_crossentropy",
             optimizer=tf.keras.optimizers.Adam(learning_rate=0.0001),
             metrics=["accuracy"])

# Trains neural network
history = model.fit(X_train, y_train, epochs=5,
                    validation_data=(X_valid,y_valid))

# Plots loss and accuracy for training and validation data
pd.DataFrame(history.history).plot(figsize=(8,5))
plt.grid(True)
plt.gca().set_ylim(0,1)
plt.show()

# Plots confusion matrix for training data
y_pred = model.predict_classes(X_train)
conf_train = confusion_matrix(y_train, y_pred)
print(conf_train)

# Evaluates model
model.evaluate(X_test,y_test)

# Plots confusion matrix for test data
y_pred = model.predict_classes(X_test)
conf_test = confusion_matrix(y_test, y_pred)
print(conf_test)

fig, ax = plt.subplots()

# Hide axes
fig.patch.set_visible(False)
ax.axis('off')
ax.axis('tight')

# Create table and save confusion matrix to file
df = pd.DataFrame(conf_test)
ax.table(cellText=df.values, rowLabels=np.arange(10),
         colLabels=np.arange(10), loc='center', cellLoc='center')
fig.tight_layout()
plt.savefig('conf_mat.pdf')