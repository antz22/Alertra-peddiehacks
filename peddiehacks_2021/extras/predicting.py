import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
from keras.models import Sequential
from keras.layers import Dense
from keras.models import model_from_json
import numpy
import os

class TrainedModel():
    def __init__(self, strImagePath, image_size, strModelPath, strWeightsPath, strDatasetPath):
        self.strImagePath = strImagePath
        self.image_size = image_size
        self.strModelPath = strModelPath
        self.strWeightsPath = strWeightsPath
        self.lstClasses = os.listdir(strDatasetPath)
        if len(self.lstClasses) == 2:
            self.strLoss = "binary_crossentropy"
        else:
            self.strLoss = "sparse_categorical_crossentropy"
    def fnLoadAndCompile(self):
        # load json and create model
        json_file = open(self.strModelPath, 'r')
        loaded_model_json = json_file.read()
        json_file.close()
        self.loaded_model = model_from_json(loaded_model_json)
        # load weights into new model
        self.loaded_model.load_weights(self.strWeightsPath)
        print("Loaded model from disk")

        self.loaded_model.compile(
            optimizer=keras.optimizers.Adam(1e-3),
            loss=self.strLoss,
            metrics=["accuracy"],
        )
    def fnPredict(self):
        fltFinalClassification = 0
        intFinalClassificationCount = 0

        img = keras.preprocessing.image.load_img(
            self.strImagePath, target_size=self.image_size
        )
        img_array = keras.preprocessing.image.img_to_array(img)
        img_array = tf.expand_dims(img_array, 0)  # Create batch axis

        predictions = self.loaded_model.predict(img_array, verbose = 1)
        score = predictions[0]
        print(score)

        for intClassificationCount, fltClassification in enumerate(predictions[0]):
            if fltClassification > fltFinalClassification:
                fltFinalClassification = fltClassification
                intFinalClassificationCount = intClassificationCount
        strClass = self.lstClasses[intFinalClassificationCount]
        return strClass