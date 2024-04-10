FROM openjdk:11-jdk-slim
LABEL key="jdk11mvn"
ARG MAVEN_VERSION=3.9.5

# Define a constant with the working directory
ARG USER_HOME_DIR="/root"

# Define the URL where maven can be downloaded from
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN apt-get update; apt-get install curl -y

# Create the directories, download maven, validate the download, install it, remove downloaded file and set links
RUN echo "Creating directories" \
    && mkdir -p /usr/share/maven/bin /usr/share/maven/ref

RUN echo "Downloading maven" \
    && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz

RUN echo "Unziping maven" \
    && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1

RUN echo "Setting links" \
    && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

RUN echo "Cleaning" \
    && rm -f /tmp/apache-maven.tar.gz \
    && apt-get autoremove -y && apt-get autoclean -y && rm -rf /var/lib/apt/lists/* && apt-get clean

# Define environmental variables required by Maven, like Maven_Home directory and where the maven repo is located
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
