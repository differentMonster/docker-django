FROM python:3.8

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install Poetry
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | POETRY_HOME=/opt/poetry python && \
    cd /usr/local/bin && \
    ln -s /opt/poetry/bin/poetry && \
    poetry config virtualenvs.create false

# install dependencies
# Copy using poetry.lock* in case it doesn't exist yet
COPY pyproject.toml poetry.lock* /

RUN poetry install --no-root --no-dev

# copy entrypoint.sh
COPY ./entrypoint.sh .

# entrypoint permissions
RUN chmod +x /entrypoint.sh

COPY . /opt/weddinghouse/

WORKDIR /opt/weddinghouse/app

RUN python manage.py makemigrations
RUN python manage.py migrate

EXPOSE 8000
#ENTRYPOINT ["/opt/weddinghouse/entrypoint.sh"]