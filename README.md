# Info:

Project for Office World by [Dmitriy Volynov]

Creates simple project wagtail, postgress in docker-compose

# Usage:

- START: docker-compose up -d --build
- Create superuser: docker-compose exec wagtail bash -c 'python $PROJECT_NAME/manage.py createsuperuser --settings=$PROJECT_NAME.settings.dev'
