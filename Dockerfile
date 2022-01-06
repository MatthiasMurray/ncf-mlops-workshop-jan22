FROM python:3.9-slim

# Allow statements and log messages to immediately appear in the Knative logs
ENV PYTHONUNBUFFERED True

RUN apt-get update \
&& apt-get install gcc -y \
&& apt-get clean

COPY . /app/

WORKDIR /app

RUN pip3.9 install --no-cache-dir -r requirements.txt

RUN pip3.9 install en_textcat_goemotions-0.0.1-py3-none-any.whl

EXPOSE 8080
ENV PORT 8080

# Run the web service on container startup. Here we use the gunicorn
# webserver, with one worker process and 8 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.
# Timeout is set to 0 to disable the timeouts of the workers to allow Cloud Run to handle instance scaling.
CMD exec gunicorn --bind :$PORT --workers 1 --threads 1 --timeout 0 main:app