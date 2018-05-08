
## New Relic Instrumentation for Kafka

This blog assumes you have a basic understanding of Kafka and will not provide an overview of the technology, the internet is full of great explanations and learning materials, so head over to [Confluent](https://www.confluent.io/) first, if you are completely new to Kafka.

New Relic does not offer direct instrumentation of a Kafka cluster, there are no extensions nor plugins that allow you to see the health and monitor the state of the Kafka Cluster.  The team at New Relic have provided guidance on how to monitor producer and consumers with a great blog titled [Kafkapocalypse](https://blog.newrelic.com/2017/12/12/new-relic-kafkapocalypse).

Although this is a great start, we wanted some more insight into the Kafka cluster itself.  As previously mentioned there is no direct instrumentation on Kafka, however Kafka does expose an extensive set of JMX metrics providing visibility in to the stack.  After some experimentation we found two options to pushing these JMX metrics to New Relic:

1). __JMXRemote Plugin__
The guys over at [3Legs](https://github.com/threelegs/newrelic-plugins) have created a Plugin that essentially allows you to connect to a remote JMX port, read the configured metrics and push them to New Relic.  

| Pros | Cons |
| ---- | ---- |
| This plugin can be run alongside an existing Kafka Cluster without changing how it is deployed, this may be beneficial in certain circumstances as the process could run using the sidecar pattern.   | Configuration is a little clunky and project looks to be stale. Even though there has not been any activity on the project for the last few years it is still fully functional.  |
| | Explicit metric config |
| | Pushes NR Metrics not Events

2). __New Relic Java Agent__
If you have full control over how your Kafka cluster is deployed you may want to consider attaching the New Relic Java Agent.  The agent allows you to connect to the JMX port from the same process as Kafka. The agent will read any metrics specified in the config and push them to New Relic.

| Pros | Cons |
| ---- | ---- |
| The agent instruments the Kafka JVM process, so no separate process to manage.  | Requires changes to how Kafka is deployed. |
| The agent is actively maintained and supported.  | Explicit metric config |
| | Pushes NR Metrics not Events

### The Mechanics

I have created a sample repository that shows these two implementations in action, checkout the codebase on [github](http://github.com/lashford/kafka-new-relic-integration).

Follow the setup instructions in the readme to test both variants of the Kafka instrumentation, The repo contains a docker compose file that starts a Kafka node with exposed JMX ports, metrics are then pushed to New Relic and can be graphed in Insights.

Once you have followed the setup instructions you can start pushing some data to Kafka so that the graphs we will create next, contain some data.

Given that you have configured the demo setup and are testing one of the options outlined above, you should be pushing data to New Relic.

#### JMX Data

Ensure the JMX metrics are being exposed by opening `jconsole` and connecting to the JMX port of the running Kafka, you can then explore the metrics.

`jconsole {LOCAL_IP}:7203`

![JConsole](https://github.com/lashford/kafka-new-relic-integration/raw/master/jconsole.png "JConsole")


#### Kafaka Load

Lets push some data through Kafka so that we can see some activity in our dashboards.  In two separate terminal windows navigate to the directory where you cloned the repository,  in one of the windows launch the following command,

`kafka-new-relic-integration > sh ./scripts/consumer.sh `

in the other window launch the following command,

`kafka-new-relic-integration > sh ./scripts/producer.sh `

you can then type any message into the terminal, this will be pushed to Kafka and consumed by the *consumer* in the other terminal window.

### Visualisation in Insights

Now that we have instrumented the app and ensured that JMX metrics are available and being pushed to New Relic, lets create some graphs.  New Relic Insights allows you to aggregate data from several sources and display them in a single unified view.  This is very useful for combining JVM metrics with host data, such as Memory, Disk IO, Disk Utilisation and CPU stats into a single dashboard.

Here is an example of the Kafka dashboard.

![Dashboard](https://github.com/lashford/kafka-new-relic-integration/raw/master/dashboard.png "New Relic Dashboard")

Unfortunately JMX data is pushed to NR as Metrics not Events, this means adding graphs to dashboards cannot be done via NQL and has to be added manually from the Metrics UI.

#### Alerts

The JMX metrics can be used to create alerts based on thresholds and baselines, alerts should be setup to alert to potential problems and further tweaked as you understand how your app performs in production.

### Conclusion

The approach you take really depends on the access you have to the Kafka deployment, we decided to opt for *option 2* and it seems to be working well for us so far...

Look out for the follow up post, which will go through the types of alerts and metrics we are using to monitor a production Kafka cluster.

Thanks for reading and remember to checkout our other blogs.

-Alex.

> Resources
> * Kafkapocalypse - blog.newrelic.com/2017/12/12/new-relic-kafkapocalypse
> * Java Agent - docs.newrelic.com/docs/agents/java-agent
> * Code Example - github.com/lashford/kafka-new-relic-integration
