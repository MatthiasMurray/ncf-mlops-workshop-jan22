# set the variables specific to your deployment
./set_variables.sh
source ./set_variables.sh

# this will build a new gcloud repo and then
# configure that repository as a remote
gcloud config set project ncf-mlops-workshop-jan-2022

# create a repo in Google Cloud
gcloud source repos create ncf-mlops-workshop-jan-2022-$_STUDENT_NAME

# set this new cloud repo as remote
PROJECT_ID=$(gcloud config get-value project)
# git remote rm origin ## UNCOMMENT IF YOU WANT TO REMOVE ORIGIN AS REMOTE DURING SETUP
git remote add google \
    "https://source.developers.google.com/p/${PROJECT_ID}/r/ncf-mlops-workshop-jan-2022-${_STUDENT_NAME}"

#create substitution YAMLs for build triggers
cat substitution-template-vars.yaml | sed -e "s/studentname/$_STUDENT_NAME/g" | sed -e "s/appname/$_APP_NAME/g" | sed -e "s/modelname/$_MODEL_NAME/g" | sed -e "s/modelversion/$_MODEL_VERSION/g" | sed -e "s/testkeys/$_TEST_KEYS/g" > substitution-vars.yaml

# dev triggers
gcloud beta builds triggers create cloud-source-repositories \
--name="${_APP_NAME}-${_STUDENT_NAME}-cloudbuild" \
--repo="ncf-mlops-workshop-jan-2022-$_STUDENT_NAME" \
--branch-pattern="^main$" \
--build-config="cloudbuild.yaml" \
--description="The build trigger for the endpoint deployed by $_STUDENT_NAME" \
--flags-file=substitution-vars.yaml


# we no longer need the specific YAMLs, so delete them locally
rm substitution-vars.yaml