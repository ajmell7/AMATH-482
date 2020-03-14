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

# Plot first 9 images
plt.figure()
for k in range(9):
    plt.subplot(3,3,k+1)
    plt.imshow(X_train_full[k], cmap="gray")
    plt.axis('off')
plt.show()

# Separate data into training and validation
X_valid = X_train_full[:5000] / 255.0
X_train = X_train_full[5000:] / 255.0
X_test = X_test / 255.0

y_valid = y_train_full[:5000]
y_train = y_train_full[5000:]

from functools import partial

# Creates baseline layer
my_dense_layer = partial(tf.keras.layers.Dense, activation="relu",
                         kernel_regularizer=tf.keras.regularizers.l2(0.00001))

# Creates all fully-connected layers
model = tf.keras.models.Sequential([
    tf.keras.layers.Flatten(input_shape=[28, 28]),
    my_dense_layer(300),
    tf.keras.layers.Dropout(0.1),
    my_dense_layer(100),
    my_dense_layer(100),
    tf.keras.layers.Dropout(0.1),
    my_dense_layer(50),
    my_dense_layer(20),
    my_dense_layer(10, activation="softmax")
])

# Adds opimizer to neural network
model.compile(loss="sparse_categorical_crossentropy",
             optimizer=tf.keras.optimizers.SGD(learning_rate=0.1),
             metrics=["accuracy"])

# Trains neural network
history = model.fit(X_train, y_train, epochs=12,
                    validation_data=(X_valid,y_valid))

# Plots loss and accuracy for training and validation data
pd.DataFrame(history.history).plot(figsize=(8,5))
plt.grid(True)
plt.gca().set_ylim(0,1)
plt.xlabel('Epoch')
plt.ylabel('Percentage')
plt.title('Loss and Accuracy for Training and Validation Data')
plt.show()

# Plots confusion matrix for training data
y_pred = model.predict_classes(X_train)
conf_train = confusion_matrix(y_train, y_pred)
print(conf_train)

# Plots confusion matrix for test data
y_pred = model.predict_classes(X_test)
conf_test = confusion_matrix(y_test, y_pred)
print(conf_test)

# Evaluates model on test data
model.evaluate(X_test,y_test)