# ncf-mlops-workshop-jan22
Contains the code to run MLOps sample deployment

## Step 1: Create Environment

We will create a python venv containing spacy and the required dependencies for model training.

## Step 2: Train model

We will clone in the spacy projects textcat_goemotions training template, modify it to only run for a fraction of the given iterations, and save the model object (a Python .whl)

Once spaCy is already available in the current working environment, you can simply run

spacy project clone tutorials/textcat_goemotions <desired_reponame>

and the template will be cloned as desired.
To use this, enter the repo and run the following two commands to, respectively, download training assets, and run the training workflow.
IMPORTANT: First, go to configs/cnn.cfg and change line 76 from `max_steps = 20000` to `max_steps = 2500` so that we don't spend forever waiting for it to train.

spacy project run assets
spacy project run all

## 