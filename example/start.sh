#!/bin/bash

docker run -d -p 9091:9091 prom/pushgateway:latest

ruby ./example.rb

docker rm $(docker stop $(docker ps -q --filter ancestor=prom/pushgateway:latest))