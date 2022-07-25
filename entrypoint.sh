#!/bin/bash

rm -rf code/static/
python manage.py collectstatic --noinput
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
aws --version
aws configure get aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure get aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws s3 sync "/code/static" s3://s3bucketname
uwsgi --master --http 0.0.0.0:8000 --wsgi-file /code/pathofthefile/wsgi.py --static-map /admin/static=/code/static --py-autoreload=1 --buffer-size=65535
