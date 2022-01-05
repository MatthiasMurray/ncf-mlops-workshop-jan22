FROM python:3.9-slim

RUN apt-get update \
&& apt-get install gcc -y \
&& apt-get clean

ADD . /app/

WORKDIR /app

RUN pip3.9 install --no-cache-dir -r requirements.txt

RUN pip3.9 install en_textcat_goemotions-0.0.1-py3-none-any.whl

EXPOSE 8080

CMD ["python3","/app/app.py"]