FROM python:3

  ENV PYTHONUNBUFFERED 1
  MAINTAINER Scott Shellabarger <scott.shellabarger@gmail.com>

  ARG github_token

  # Clone our private GitHub Repository
  RUN git clone https://${github_token}:x-oauth-basic@github.com/PyArk/pyconark /pyconark/

  #move repo and install requirements
  RUN cp -R /pyconark/* /app/
  RUN pip install --upgrade pip
  RUN pip install -r /app/requirements.txt
  RUN python /app/manage.py makemigrations
  RUN python /app/manage.py migrate

  # Clean-up and move a file
  RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /pyconark/
  RUN mv app.py main.py
