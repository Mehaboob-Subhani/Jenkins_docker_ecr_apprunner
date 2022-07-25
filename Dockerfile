FROM python:2.7

LABEL maintainer="ms"

ENV PYTHONUNBUFFERED 1

RUN mkdir /code

WORKDIR /code

# Add requirements.txt file to container
ADD requirements.txt /code/

#install requirements
RUN pip install -r /code/requirements.txt

ADD entrypoint.sh /code/

RUN chmod 755 /code/entrypoint.sh

# Add the current directory(the web folder) to the docker folder 
ADD . /code/

ENTRYPOINT ["sh", "/code/entrypoint.sh"]
