import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
import os
from datetime import datetime
import inspect

class RitModel():
    def __init__(self, strMainPath, strDataset, image_size, batch_size, intEpochs):
        self.strMainPath = strMainPath
        self.strDataset = strDataset
        self.strDatasetPath = os.path.join(self.strMainPath, self.strDataset)
        self.image_size = image_size
        self.batch_size = batch_size
        self.input_shape = self.image_size + (3,)
        self.lstClasses = os.listdir(os.path.join(self.strDatasetPath, "train"))
        self.num_classes = len(self.lstClasses)
        self.intEpochs = intEpochs
    def fnLoadDatasets(self):
        train_ds = tf.keras.preprocessing.image_dataset_from_directory(
            os.path.join(self.strDatasetPath, "train"),
            # validation_split=0.2,
            # subset="training",
            seed=1337,
            image_size=self.image_size,
            batch_size=self.batch_size,
        )
        val_ds = tf.keras.preprocessing.image_dataset_from_directory(
            os.path.join(self.strDatasetPath, "test"),
            # validation_split=0.2,
            # subset="validation",
            seed=1337,
            image_size=self.image_size,
            batch_size=self.batch_size,
        )

        self.data_augmentation = keras.Sequential(
            [
                layers.experimental.preprocessing.RandomFlip("horizontal"),
                layers.experimental.preprocessing.RandomRotation(0.1),
            ]
        )

        self.train_ds = train_ds.prefetch(buffer_size=32)
        self.val_ds = val_ds.prefetch(buffer_size=32)
    def fnMakeModel(self):
        inputs = keras.Input(shape=self.input_shape)
        # Image augmentation block
        x = self.data_augmentation(inputs)

        # Entry block
        x = layers.experimental.preprocessing.Rescaling(1.0 / 255)(x)
        x = layers.Conv2D(32, 3, strides=2, padding="same")(x)
        x = layers.BatchNormalization()(x)
        x = layers.Activation("relu")(x)

        x = layers.Conv2D(64, 3, padding="same")(x)
        x = layers.BatchNormalization()(x)
        x = layers.Activation("relu")(x)

        previous_block_activation = x  # Set aside residual

        for size in [128, 256, 512, 728]:
            x = layers.Activation("relu")(x)
            x = layers.SeparableConv2D(size, 3, padding="same")(x)
            x = layers.BatchNormalization()(x)

            x = layers.Activation("relu")(x)
            x = layers.SeparableConv2D(size, 3, padding="same")(x)
            x = layers.BatchNormalization()(x)

            x = layers.MaxPooling2D(3, strides=2, padding="same")(x)

            # Project residual
            residual = layers.Conv2D(size, 1, strides=2, padding="same")(
                previous_block_activation
            )
            x = layers.add([x, residual])  # Add back residual
            previous_block_activation = x  # Set aside next residual

        x = layers.SeparableConv2D(1024, 3, padding="same")(x)
        x = layers.BatchNormalization()(x)
        x = layers.Activation("relu")(x)

        x = layers.GlobalAveragePooling2D()(x)
        if self.num_classes == 2:
            activation = "sigmoid"
            units = 1
            self.strLoss = "binary_crossentropy"
        else:
            activation = "softmax"
            units = self.num_classes
            self.strLoss = "sparse_categorical_crossentropy"

        x = layers.Dropout(0.5)(x)
        outputs = layers.Dense(units, activation=activation)(x)
        return keras.Model(inputs, outputs)
    def fnFinishModel(self):
        model = self.fnMakeModel()

        model.compile(
            optimizer=keras.optimizers.Adam(1e-3),
            loss=self.strLoss,
            metrics=["accuracy"],
        )
        model.fit(
            self.train_ds, epochs=self.intEpochs, validation_data=self.val_ds,
        )

        intModelNumber = 1
        datNow = datetime.now()
        strTimestamp = int(datetime.timestamp(datNow))

        # serialize model to JSON
        model_json = model.to_json()
        with open(os.path.join("C:\\Users\\suchi\\Dropbox (Sandipan.com)\\Creative\\RitiCode\\Image Recognition Experiment", "{}_model-{}.json".format(self.strDataset, strTimestamp)), "w") as json_file:
            json_file.write(model_json)
        # serialize weights to HDF5
        model.save_weights(os.path.join("C:\\Users\\suchi\\Dropbox (Sandipan.com)\\Creative\\RitiCode\\Image Recognition Experiment", "{}_model-{}.h5".format(self.strDataset, strTimestamp)))
        print("Saved model to disk")