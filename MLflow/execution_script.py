...

### Framework imports ###

...

# Import mlflow and framework support

import mlflow
import mlflow.[keras|tensorflow|sklearn]

# Setup Experiment Tracker

tracking_uri='file:///root/mlflow'
mlflow.set_tracking_uri(tracking_uri)

experiment_name = 'name'
mlflow.set_experiment(experiment_name)  

...

### Framework specific model training code ###

...

# Start the MLflow run
with mlflow.start_run():
    history = model.fit(x_train, y_train,
                    batch_size=batch_size,
                    epochs=epochs,
                    verbose=1,
                    validation_split=0.1)
    score = model.evaluate(x_test, y_test,
                       batch_size=batch_size, verbose=1)
    print('Test score:', score[0])
    print('Test accuracy:', score[1])