FROM python:3.6.6

ARG github_token

# Clone our private GitHub Repository
RUN git clone https://${github_token}:x-oauth-basic@github.com/PyArk/pyconark /pyconark/

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*

#install requirements
WORKDIR /pyconark
RUN pip install --upgrade pip
COPY requirements.txt ./
RUN pip install -r requirements.txt

#make and run migrate scripts for DB
RUN python manage.py makemigrations
RUN python manage.py migrate

COPY . .

#start django
EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
