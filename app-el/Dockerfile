FROM python:3.8-slim

RUN apt-get update && apt-get install -y build-essential

COPY requirements.txt /opt/requirements.txt
RUN pip install --upgrade pip && pip install -r /opt/requirements.txt

ENV BUCKET_NAME=${BUCKET_NAME}

ARG APP_DIR=/app
RUN mkdir $APP_DIR
COPY . $APP_DIR/

ENV PYTHONPATH $APP_DIR/src
WORKDIR $APP_DIR/src

# Run the web service on container startup.
CMD ["python3", "main.py"]


