FROM maven:3.8.3-openjdk-16 AS build

RUN mkdir -p /usr/src/application-src
COPY helloWorld17/ /usr/src/application-src/

WORKDIR /usr/src/application-src/

RUN mvn clean install


FROM openjdk:16-jdk-buster

RUN mkdir /usr/app

COPY --from=build /usr/src/application-src/target/helloWorld17-0.0.1-SNAPSHOT.jar /usr/app/helloWorld17-0.0.1-SNAPSHOT.jar

WORKDIR /usr/app

ENTRYPOINT ["java","-jar","helloWorld17-0.0.1-SNAPSHOT.jar"]