# Observability in Selenium
A project to showcase Selenium 4's Tracing capability using OpenTelemetry APIs(Jaeger) with Selenium Grid
 

## Selenium 4

It has number of new exciting features and one such is a cleaner code for Selenium Grid along with support for distributed tracing via OpenTelemetry APIs. This is pretty exciting and important feature for the admins and devops engineers to trace the flow of control through the Grid for each and every command.

Distributed tracing has two parts:

Code instrumentation: Adding instrumentation code in your application to produce traces. The major instrumentation parts are done neatly by the developers of Selenium project, which leaves us to consume it by using Selenium Grid start-up command along with Jaeger.

Collection of data and providing meaning over it, Jaeger has a UI which allows us to view traces visually well.

Steps to start tracing your tests,

Start Jaeger via docker(as its easy)

Instrument your Selenium Grid start-up command with Jaeger tracing as in start-grid-distributed.sh distributed mode.

Now execute your tests, and navigate to http://localhost:16686/ to view the outputs.

## Pre-requisites
Assuming you have docker running on your machine,
1. Install Coursier via homebrew `brew install coursier/formulas/coursier`
2. Install [Jaeger](https://www.jaegertracing.io/download/) via docker
3. Selenium-server.jar refers to the latest alpha version of selenium releases (Tested with Apha 5)

## Start Jaeger via docker server
The simplest way to start the all-in-one is to use the pre-built image published to DockerHub (a single command line).

```
$ docker run --rm -it --name jaeger \
    -p 16686:16686 \
    -p 14250:14250 \
    jaegertracing/all-in-one:1.17
  ```
You can then navigate to http://localhost:16686 to access the Jaeger UI.

## Instrument your Selenium Grid command
We're going to add support for Open Telemetry API's(one of the many ways to do distributed tracing) using [Coursier](https://get-coursier.io/docs/overview) to generate a full classpath, when started this way the selenium server will inform you that it has found a tracer on stdout.

Refer [start-grid-distributed.sh](/start-grid-distributed.sh) if you want to start Grid in distributed mode.

```curl http://localhost:4444/status``` to check if your grid deployment is ready

![Grid status](/images/selenium_grid_status.jpg)

## Execute your tests
Point your tests as in [DistributedTracingExamples](src/test/java/com/vin/tests/GridTest.java) Class and navigate to http://localhost:16686/ to view the outputs.

Under services look up for Selenium-router and notices actions for each calls made by your tests. An example below

![Traces](/images/jaeger_traces.jpg)

References:
* [Tracing Info command](https://github.com/SeleniumHQ/selenium/)
* [Jaeger guide](https://www.jaegertracing.io/docs/1.17/getting-started/)
* [Three Pillars of Observability](https://learning.oreilly.com/library/view/distributed-systems-observability/9781492033431/ch04.html)

A special thanks to [Manoj Kumar](https://github.com/manoj9788) and [Puja Jagani](https://github.com/pujagani) for knowledge sharing on these capabilities.