FROM ubuntu:20.04
LABEL maintainer="Nikolay Pyatakov  <pyatakovns@mail.ru>"

# Install java
RUN apt-get update \
 && apt-get install --no-install-recommends -y \
 wget \
 gnupg2 \
 default-jdk

# Install ChromeDriver
ENV CHROME_DRIVER_VERSION 111.0.5563.64
RUN apt-get update && apt-get install -y curl unzip \
 && curl -O https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip \
 && unzip chromedriver_linux64.zip -d /usr/bin \
 && rm chromedriver_linux64.zip

# Install google-chrome-stable
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \ 
 && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN apt-get update && apt-get -y install google-chrome-stable

# Install maven
ARG MAVEN_VERSION=3.6.3
ARG USER_HOME_DIR="/root"
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
 && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
 && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
 && rm -f /tmp/apache-maven.tar.gz \
 && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

WORKDIR /app

COPY . .
