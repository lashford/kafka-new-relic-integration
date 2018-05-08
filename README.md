
# Kafka New Relic Integration  

This repo contains a working example of how to push Kafka JMX values to new relic, the repo contains a docker compose environment with a Kafka node and configurations for two plugins to extract the JMX stats to your New Relic Account.

* Option 1 - __JMXRemote Plugin__
* Option 2 - __New Relic Java Agent__

## Prerequisites:
* Java (JDK)
* docker-compose

## Pre-Setup:

### New Relic License
To enable this demo to push data to New Relic you will need to configure the license key, this is available from the new relic account setting UI [here](https://newrelic.com/docs/subscriptions/license-key).

Replace the placeholder 'NR_LICENSE' with you key in the following files:

* `newrelic_3legs_plugin-2.0.0/config/newrelic.json`
* `newrelic-java-agent/newrelic.yml`

### Local Host IP
 To enable the remote JMX connection to work with both plugins, set the `HOST_IP` placeholder to your local machine ip in the following files:

 * `docker-compose.yml`
 * `scripts/consumer.sh`
 * `scripts/producer.sh`


## Pick the plugin

### JMXRemote Plugin

To run option 1 comment out the `KAFKA_OPTS` variable in `Docker-compose.yml` you can then run the following two commands in two separate terminal windows:

* `$ docker-compose up` wait for output in the terminal to report `Kafka started`

then run

* `$ java -jar plugin.jar`

### New Relic Java Agent

To run option 2 ensure you have not made changes to `KAFKA_OPS` in the compose file.  Then run:

* `$ docker-compose up` wait for output in the terminal to report `Kafka started`

## Send Some Data

Lets use the __Producer__ & __Consumer__ clients inside the Kafka container, I have created two helper scripts to make connection easier, in two separate terminal windows run the following two scripts.

In the first window `$ sh scripts/producer.sh`

In the second window `$ sh scripts/consumer.sh`

In the `Producer` window you can input text which will be sent as `messages` to the `messages` topic, the `Consumer` window will then print those messages out to the terminal.

## Local visibility

You can launch `jconsole` or `visualVm` to connect to the JMX port of the Kafka instance, this will provide a list of the JMX variables and will allow customisation of the plugins.

launch `jconsole` with the following command from a new terminal window. `jconsole {LOCAL_IP}:7203`

## Controlling JMX Events

What JMX metrics are pushed to NR are configured in the `plugin.json` and the `newrelic.yml` files for each of the plugins respectively.

## Credits and further reading:

* [NR Java agent docs](https://docs.newrelic.com/docs/agents/java-agent)

* [NR Java agent install docs](https://docs.newrelic.com/docs/agents/java-agent/installation/install-java-agent)

* [latest NR Java agent](https://oss.sonatype.org/content/repositories/releases/com/newrelic/agent/java/newrelic-java/3.42.0/)

* [3 legs Nr Plugin](https://github.com/threelegs/newrelic-plugins)
