FROM python:3.9-slim

# Allow statements and log messages to immediately appear in the Knative logs
ENV PYTHONUNBUFFERED True

# Install C compiler and some other low-level dependencies
RUN apt-get update \
&& apt-get install gcc -y \
&& apt-get clean

# Move the contents of the codebase into the Docker container
COPY . /app/

# Set the working directory
WORKDIR /app

# Install the Python dependencies
RUN pip3.9 install --no-cache-dir -r requirements.txt

# Install the spaCy model (which we have saved as a Python .whl so we can pip install)
RUN pip3.9 install ${_MODEL_NAME}-${_MODEL_VERSION}-py3-none-any.whl

# Open up port 8080 on this container so the traffic occuring on that port can be used
EXPOSE 8080
ENV PORT 8080

# Run the web service on container startup. Here we use the gunicorn
# webserver, with one worker process and 8 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.
# Timeout is set to 0 to disable the timeouts of the workers to allow Cloud Run to handle instance scaling.
CMD exec gunicorn --bind :$PORT --workers 1 --threads 1 --timeout 0 app:app