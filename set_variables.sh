# you would only change this if you were changing the model name in project.yml during the spaCy training
export _MODEL_NAME='en_textcat_goemotions'

# same with this, except with changing model version number
export _MODEL_VERSION=0.0.1

# this should be whatever the expected keys of the output JSON from the /predict method are.
# unit test will check for the presence of these on an input message (checking for form not accuracy)
export _TEST_KEYS='admiration,amusement,anger,annoyance,approval,caring,confusion,curiosity,desire,disappointment,disapproval,disgust,embarrassment,excitement,fear,gratitude,grief,joy,love,nervousness,optimism,pride,realization,relief,remorse,sadness,surprise,neutral'

# this is the same for everyone during this workshop but change this if you use for another app
export _APP_NAME='ncf-mlops-workshop-jan22'

# your name in the form first letter of first name followed by last name
# (alternatively, your NCF email without punctuation)
export _STUDENT_NAME='mmurray'