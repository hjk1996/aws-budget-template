#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
docker build -t lambda-python-311 "$SCRIPT_DIR"
docker run --rm --platform=linux/amd64 --name lambda-python-311 -v $SCRIPT_DIR:/var/task lambda-python-311 bash -c "pip install pandas boto3 requests -t /opt/python && cd /opt && zip -r /var/task/lambda_layer.zip python"
