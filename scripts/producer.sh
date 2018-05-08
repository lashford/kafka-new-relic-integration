#!/bin/bash

docker run --rm --interactive ches/kafka kafka-console-producer.sh --topic messages --broker-list ${HOST_IP}:9092
