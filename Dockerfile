FROM python:3.9-slim as builder

WORKDIR /usr/src/app

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

COPY requirements.txt .

RUN pip install --upgrade pip \
    && pip wheel --no-cache-dir --no-deps --wheel-dir wheels -r requirements.txt


FROM python:3.9-slim

ARG WORKDIR=/usr/src/app
ARG PROJECT_NAME=mysite
ARG PORT=8000

ENV PYTHONUNBUFFERED=1 \ 
    PYTHONDONTWRITEBYTECODE=1 \
    PORT=$PORT \
    PROJECT_NAME=$PROJECT_NAME

EXPOSE $PORT

WORKDIR $WORKDIR

ARG PROJECT_NAME=mysite

COPY --from=builder $WORKDIR/wheels /wheels

RUN pip install --upgrade pip \ 
    && pip install --no-cache /wheels/* \
    && wagtail start $PROJECT_NAME \
    && useradd -ms /bin/bash wagtail \
    && chown -R wagtail:wagtail $WORKDIR

COPY entrypoint.sh $WORKDIR
COPY dev.py $PROJECT_NAME/$PROJECT_NAME/settings/dev.py

USER wagtail

ENTRYPOINT ["./entrypoint.sh"]
CMD ["/bin/bash", "-c", "exec python $PROJECT_NAME/manage.py runserver 0.0.0.0:$PORT --settings=$PROJECT_NAME.settings.dev"]
