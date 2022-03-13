 # local build command : docker build -t lisandro.rafaelano/helloworld16 .

FROM maven:3.8.3-openjdk-16 AS build

RUN mkdir -p /usr/src/application-src
COPY helloworld16/ /usr/src/application-src/

WORKDIR /usr/src/application-src/

RUN mvn clean install

RUN ls -ls /usr/src/application-src/target/


FROM openjdk:16-jdk-buster

RUN mkdir /usr/app

COPY --from=build /usr/src/application-src/target/helloworld16.jar /usr/app

WORKDIR /usr/app

ENTRYPOINT ["java","-jar","helloworld16.jar"]