#!/bin/bash -x
ps auxw | grep selenium-server-4.3.0.jar | awk '{print $2}' | xargs kill

java -Dotel.traces.exporter=jaeger \
     -Dotel.exporter.jaeger.endpoint=http://localhost:14250 \
     -Dotel.resource.attributes=service.name=selenium-event-bus \
     -jar selenium-server-4.3.0.jar \
     --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporter-jaeger:1.15.0 \
        io.grpc:grpc-netty:1.45.0) \
     event-bus &
sleep 2
java -Dotel.traces.exporter=jaeger \
     -Dotel.exporter.jaeger.endpoint=http://localhost:14250 \
     -Dotel.resource.attributes=service.name=selenium-sessions \
     -jar selenium-server-4.3.0.jar \
     --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporter-jaeger:1.15.0 \
        io.grpc:grpc-netty:1.45.0) \
     sessions &
sleep 2
java -Dotel.traces.exporter=jaeger \
     -Dotel.exporter.jaeger.endpoint=http://localhost:14250 \
     -Dotel.resource.attributes=service.name=selenium-session-queue \
     -jar selenium-server-4.3.0.jar \
     --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporter-jaeger:1.15.0 \
        io.grpc:grpc-netty:1.45.0) \
     sessionqueue &
sleep 5
java -Dotel.traces.exporter=jaeger \
     -Dotel.exporter.jaeger.endpoint=http://localhost:14250 \
     -Dotel.resource.attributes=service.name=selenium-distributor \
     -jar selenium-server-4.3.0.jar \
     --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporter-jaeger:1.15.0 \
        io.grpc:grpc-netty:1.45.0) \
     distributor --sessions http://localhost:5556 --sessionqueue http://localhost:5559 --bind-bus false &
sleep 2
java -Dotel.traces.exporter=jaeger \
     -Dotel.exporter.jaeger.endpoint=http://localhost:14250 \
     -Dotel.resource.attributes=service.name=selenium-router \
     -jar selenium-server-4.3.0.jar \
     --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporter-jaeger:1.15.0 \
        io.grpc:grpc-netty:1.45.0) \
     router --sessions http://localhost:5556 --sessionqueue http://localhost:5559 --distributor http://localhost:5553 &
sleep 2
java -Dotel.traces.exporter=jaeger \
     -Dotel.exporter.jaeger.endpoint=http://localhost:14250 \
     -Dotel.resource.attributes=service.name=selenium-node \
     -jar selenium-server-4.3.0.jar \
     --ext $(coursier fetch -p \
        io.opentelemetry:opentelemetry-exporter-jaeger:1.15.0 \
        io.grpc:grpc-netty:1.45.0) \
     node -D selenium/standalone-firefox:4.3.0-20220706 '{"browserName": "firefox"}' --detect-drivers false &