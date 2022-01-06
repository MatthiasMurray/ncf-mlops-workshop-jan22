# ncf-mlops-workshop-jan22
Contains the code to run MLOps sample deployment

## Step 1: Create Environment

To keep our work separate from other software on your computer, we will create a python venv containing spacy and the required dependencies for model training. Run the below in the terminal:

`python3 -m venv mlops-venv`

Activate/enter the environment so we can start installing the needed packages:

`source mlops-venv/bin/activate`

Finally, install libraries needed for training:

`pip install spacy`

`pip install wheel`

If you didn't have any issues performing these steps, you should now see `(mlops-venv)` at the start of each terminal line and you are now ready to begin the workshop!
If you have any issues with this step, for example in creating the venv or performing the pip install, let me know and I will check that the required software is installed on your shell.

## Step 2: Train model

The spaCy projects repository contains some easy-start templates for common training situations that can be used out of the box. We will clone in the spacy projects textcat_goemotions training template, modify it to only run for a fraction of the given iterations, and save the model object (a Python `.whl`)

Once spaCy is already available in the current working environment, you can simply run:

`spacy project clone tutorials/textcat_goemotions`

The `textcat_goemotions` template should have be cloned as desired as a result of this command. _NOTE: it is extremely uncommon for Python projects/repositories/libraries to re-implement git as in the clone feature here, this is just included as a matter of convenience in this repository_

**IMPORTANT**: Next, open `textcat_goemotions/configs/cnn.cfg` in the IDE file explorer and change line 76 from `max_steps = 20000` to `max_steps = 2500` so that we don't spend forever waiting for it to train. It will not be as accurate as it could be, but we want to get started with deployment as soon as possible since we can always retrain the model and deploy a better version later.

Once you have changed this configuration setting, **SAVE THE `cnn.cfg` FILE** and then run the below steps in the shell:

 - Change directories to put you inside of `textcat_goemotions` instead of the parent directory we cloned from GitHub:

 `cd textcat_goemotions`

 - Download the data used to train the model from a file location hosted by GitHub -- note that it is not normal for file downloads to be so cleanly accessible, but this is meant to be out of the box, and the format of the downloaded files can be viewed by accessing the assets URLs in the `project.yml`:

 `spacy project assets`

 - Run training workflow defined in `project.yml` including parsing the data, training as specified by the configuration file `configs/cnn.cfg`, and packaging the model as a `.whl`:

 `spacy project run all`

If the above steps are performed correctly, the training should run for several minutes but not more than 10-15 minutes. The result should be a number of log outputs, the last of which will state:

```
✔ Successfully created binary wheel
packages/en_textcat_goemotions-0.0.1/dist/en_textcat_goemotions-0.0.1-py3-none-any.whl
```

## Step 3: Install and Test Model
If we scroll up a bit we will see logs describing the accuracy of the model on different classes on the holdout data. This was a very short training run and there are several classes so the model may not be very performant yet, but it looks like the 'gratitude' class has particularly promising statistics. Let's try a few inputs to see if they can be properly predicted. Since we have the `.whl` file, we can pip install that:

`pip install packages/en_textcat_goemotions-0.0.1/dist/en_textcat_goemotions-0.0.1-py3-none-any.whl`

This enables us to call the most recently installed version of the model very easily. We can open up a Python shell:

```
(mlops-venv) Matthiass-MBP:textcat_goemotions Matthias$ python3
Python 3.6.4 |Anaconda, Inc.| (default, Jan 16 2018, 12:04:33) 
[GCC 4.2.1 Compatible Clang 4.0.1 (tags/RELEASE_401/final)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> import spacy
>>> nlp = spacy.load('en_textcat_goemotions')
>>> doc1 = nlp("Oh thank you so much")
>>> doc2 = nlp("He's the absolute worst")
>>> doc1.cats
{'admiration': 0.000298079801723361, 'amusement': 0.0001873411820270121, 'anger': 0.00045573318493552506, 'annoyance': 0.0010960042709484696, 'approval': 0.0005200382438488305, 'caring': 0.006497371941804886, 'confusion': 0.0002659869787748903, 'curiosity': 0.004305544774979353, 'desire': 0.0004700781428255141, 'disappointment': 0.0009327976731583476, 'disapproval': 5.0297552661504596e-05, 'disgust': 0.0005213449476286769, 'embarrassment': 0.0005270974361337721, 'excitement': 0.002492794068530202, 'fear': 0.00032478771754540503, 'gratitude': 1.0, 'grief': 0.0007282516453415155, 'joy': 0.011997749097645283, 'love': 0.00017659502918832004, 'nervousness': 1.2611227248271462e-05, 'optimism': 0.0005079426919110119, 'pride': 0.0007393326959572732, 'realization': 0.0003374861553311348, 'relief': 8.838210487738252e-05, 'remorse': 0.003941522445529699, 'sadness': 0.006727407220751047, 'surprise': 0.0014914583880454302, 'neutral': 9.650528227211908e-05}
>>> doc2.cats
{'admiration': 0.04335942491889, 'amusement': 0.0007425163057632744, 'anger': 0.09001421928405762, 'annoyance': 0.1322454810142517, 'approval': 0.01628461852669716, 'caring': 0.002383623505011201, 'confusion': 0.004516026470810175, 'curiosity': 0.004065715707838535, 'desire': 0.0005966019816696644, 'disappointment': 0.026818308979272842, 'disapproval': 0.004810329992324114, 'disgust': 0.045298997312784195, 'embarrassment': 0.0015444468008354306, 'excitement': 0.008474141359329224, 'fear': 0.025346679612994194, 'gratitude': 6.745914288330823e-05, 'grief': 0.007564100436866283, 'joy': 0.02041621319949627, 'love': 0.0009323504054918885, 'nervousness': 0.00045968848280608654, 'optimism': 0.004582526162266731, 'pride': 0.0007694598170928657, 'realization': 0.002781932707875967, 'relief': 0.002334031043574214, 'remorse': 0.0037643585819751024, 'sadness': 0.014285258017480373, 'surprise': 0.014348187483847141, 'neutral': 0.008007450960576534}
```

There are a lot of fields, but the test response "Oh thank you so much" got an almost perfect score on the 'gratitude' label, while the test response "He's the absolute worst" got its highest score in the 'annoyance' label, but at about 0.13 this might not be detected, depending on how you use the model. Regardless, we have a model, so let's move on!

## Step 4: Flask App

We will use Flask as a simple framework for delivering HTTP requests taking the form of the tests from the previous step. The idea is, we will host a Flask app, that will have a URL associated with it, and when we send JSON similar to `{"response":"Some message"}` as a payload, we will get back a payload with the above JSON of predictions.
We will be making partial use of the Python quickstart in this guide for the next few steps: https://cloud.google.com/run/docs/quickstarts

In order to run the Flask app, install Flask and gunicorn:

`pip install Flask==2.0.2`

`pip install gunicorn==20.1.0`

Then we can run the app locally. Navigate to the root of this repository (`ncf-mlops-workshop-jan22`) and then run the Flask app from the shell:
`python3 app.py`

You will get some logs telling you what the location of the Flask server is on your local machine:

```
(mlops-venv) Matthias@Matthiass-MBP ncf-mlops-workshop-jan22 % python3 app.py 
 * Serving Flask app 'app' (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: on
 * Running on all addresses.
   WARNING: This is a development server. Do not use it in a production deployment.
 * Running on http://192.168.1.31:8080/ (Press CTRL+C to quit)
 * Restarting with stat
 * Debugger is active!
 * Debugger PIN: 353-036-223
```

Therefore, we can use the Python `requests` library to check and make sure this is delivering model inference as desired. Enter a Python shell:

```
Matthiass-MBP:ncf-mlops-workshop-jan22 Matthias$ python3
Python 3.6.4 |Anaconda, Inc.| (default, Jan 16 2018, 12:04:33) 
[GCC 4.2.1 Compatible Clang 4.0.1 (tags/RELEASE_401/final)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> import requests
>>> import json
>>> content_json = json.loads(requests.post('http://192.168.1.31:8080/predict',json={"response":"He is the worst!"}).content)
>>> content_json['annoyance']
0.12393056601285934
```

Great, so we have a Flask app. Terminate the process with Ctl-C to cancel.

## Step 5a: Dockerize
The Dockerfile provided contains the information necessary to containerize this Flask application.

_NOTE: This section is not necessary to complete the deployment_

If we wanted to dockerize and run this container locally, we would go to our repository root and build:

`docker build . --tag SOME_CONTAINER_NAME`

If the Docker daemon is running and has sufficient resources, this should result in logs showing the pip installs and other setup steps that are outlined in the Dockerfile as they are performed and the image is built.

To test and see if the container is running correctly, you could run (using the same container name as above):

`docker run -d -p 8080:8080 SOME_CONTAINER_NAME`

This will output the container ID if it is successful. To check that it is running, you can enter:

`docker container list`

This will output something like the below (I used the container name `workshopcontainerjan22` instead of `SOME_CONTAINER_NAME`):

```
(mlops-venv) Matthias@Matthiass-MBP ncf-mlops-workshop-jan22 % docker container list
CONTAINER ID   IMAGE                    COMMAND                  CREATED         STATUS         PORTS                                       NAMES
63a825cedd19   workshopcontainerjan22   "/bin/sh -c 'exec gu…"   8 minutes ago   Up 8 minutes   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   zen_pike
```

This just means that the application is listening for requests on the appropriate ports and we can make requests (here on http://0.0.0.0:8080 based on the numbers shown). As expected, a Python shell will be able to interact with the container:

```
>>> content_json = json.loads(requests.post('http://0.0.0.0:8080/predict',json={"response":"He is the worst!"}).content)
>>> content_json['annoyance']
0.12393056601285934
```

You can stop this running container by noting the NAME at the end of the row entry resulting from `docker container list`. Above, this container was automatically named `zen_pike` by the Docker daemon, so we can just run the following to stop the container:

`docker kill zen_pike`

## Step 5: Deploy
We will be using Cloud Run to actually perform this deployment. This is a resource offered by Google Cloud that can build and run containerized applications. It happens to be a convenient way to serve simple Flask applications like this one.

Requirements:
 - You have an account with access to GCP Project
 - You have Google Cloud SDK installed

First, login:

`gcloud auth login`

Should open your Chrome browser where you can login to your GCP account, usually a gmail account. Once you have done this your shell will have authorization to access project resources.

Then, to perform the deployment, run the following command:

```
gcloud run deploy --source . \
--platform=managed \
--concurrency=1 \
--cpu=1 \
--memory=1G \
--allow-unauthenticated
```

This may prompt you to allow certain APIs, or warn you that you need certain permissions. I can provide access to privileges as students reach this point. If asked to allow access to the APIs, approve it by hitting Enter or pressing 'y'. When prompted for zone, you can enter 24 for us-east1 and hit Enter.

If all works, the below should result:

```
Service name (ncf-mlops-workshop-jan22):  
Please specify a region:
 [1] asia-east1
 [2] asia-east2
 [3] asia-northeast1
 [4] asia-northeast2
 [5] asia-northeast3
 [6] asia-south1
 [7] asia-south2
 [8] asia-southeast1
 [9] asia-southeast2
 [10] australia-southeast1
 [11] australia-southeast2
 [12] europe-central2
 [13] europe-north1
 [14] europe-west1
 [15] europe-west2
 [16] europe-west3
 [17] europe-west4
 [18] europe-west6
 [19] northamerica-northeast1
 [20] northamerica-northeast2
 [21] southamerica-east1
 [22] southamerica-west1
 [23] us-central1
 [24] us-east1
 [25] us-east4
 [26] us-west1
 [27] us-west2
 [28] us-west3
 [29] us-west4
 [30] cancel
Please enter your numeric choice:  24

To make this the default region, run `gcloud config set run/region us-east1`.

This command is equivalent to running `gcloud builds submit --tag [IMAGE] .` and `gcloud run deploy ncf-mlops-workshop-jan22 --image [IMAGE]`

Building using Dockerfile and deploying container to Cloud Run service [ncf-mlops-workshop-jan22] in project [ncf-mlops-workshop-jan-2022] region [us-east1]
✓ Building and deploying... Done.                                                                                
  ✓ Uploading sources...                                                                                         
  ✓ Building Container... Logs are available at [https://console.cloud.google.com/cloud-build/builds/b55b1e33-ef0
  a-4efb-9aec-9cc0bb41aa4f?project=418055566548].                                                                
  ✓ Creating Revision...                                                                                         
  ✓ Routing traffic...                                                                                           
  ✓ Setting IAM Policy...                                                                                        
Done.                                                                                                            
Service [ncf-mlops-workshop-jan22] revision [ncf-mlops-workshop-jan22-00013-bos] has been deployed and is serving 100 percent of traffic.
Service URL: https://ncf-mlops-workshop-jan22-4lk5kh4waa-ue.a.run.app
```

You should now be able to make requests at the URL shown above, with the `/predict` suffix path included as in testing.