FROM python:3.6.0-alpine

WORKDIR /app
COPY . /app/

RUN apk --no-cache --update add build-base \
    && pip install --upgrade pip \
    && pip install -r /app/requirements.txt \
    && apk del build-base

ENV POST_DATABASE_HOST mongo_db
ENV POST_DATABASE posts

CMD ["python3", "post_app.py"]
