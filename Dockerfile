FROM python:3.11-bookworm

ENV DEBIAN_FRONTEND noninteractive

# doc

# ENV MINIO_URL cdn.funceme.br
ENV SQLALCHEMY_ECHO True
ENV SQLALCHEMY_COMMIT_ON_TEARDOWN True
ENV SQLALCHEMY_TRACK_MODIFICATIONS True
ENV SQLALCHEMY_RECORD_QUERIES True
ENV SQLALCHEMY_POLL_SIZE 20
ENV SQLALCHEMY_MAX_OVERFLOW 30

ENV BABEL_DEFAULT_LOCALE pt_BR

ENV UPLOAD_FOLDER app/static/uploads/

RUN apt-get update && \
    apt-get install -y nginx tzdata pkg-config && \
    rm -rf /var/lib/apt/lists/*

ENV TZ America/Fortaleza
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

COPY nginx.conf /etc/nginx/nginx.conf
COPY ./app/ /app/
COPY requirements.txt requirements.txt

RUN pip install --upgrade pip
# RUN python3.11 -m pip install -r /requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

CMD gunicorn --bind 0.0.0.0:8000 app:app --daemon & nginx -g 'daemon off;'