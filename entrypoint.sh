#!/bin/bash

if [ "$DATABASE" = "postgres" ]
then
    echo "Waiting for postgres..."

    while ! nc -z $SQL_HOST $SQL_PORT; do
      sleep 0.1
    done

    echo "PostgreSQL started"
fi

python $PROJECT_NAME/manage.py makemigrations --settings=$PROJECT_NAME.settings.dev
python $PROJECT_NAME/manage.py migrate --settings=$PROJECT_NAME.settings.dev

exec "$@"
