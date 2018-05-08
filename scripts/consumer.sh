#!/bin/bash

docker run --rm ches/kafka kafka-console-consumer.sh --topic messages --from-beginning --bootstrap-server ${HOST_IP}:9092
