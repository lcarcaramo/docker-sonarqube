# Tags
> _Built from [`quay.io/ibm/openjdk:11.0.8`](https://quay.io/repository/ibm/openjdk?tab=info)_
-	`8.5.1.38104` - [![Build Status](https://travis-ci.com/lcarcaramo/docker-sonarqube.svg?branch=master)](https://travis-ci.com/lcarcaramo/docker-sonarqube)

### __[Original Source Code](https://github.com/SonarSource/docker-sonarqube)__

# SonarQube

[SonarQube](https://www.sonarqube.org/) is an open source product for continuous inspection of code quality.

![logo](https://raw.githubusercontent.com/docker-library/docs/84479f149eb7d748d5dc057665eb96f923e60dc1/sonarqube/logo.png)

# Security
Ensure that you are treating all SonarQube instances that handle proprietary/internal source code as production SonarQube instances by implementing all of the security features that you would implement on any internal production system.

See the [SonarQube Security](https://docs.sonarqube.org/latest/instance-administration/security/) documentation to learn how to enable application level security in SonarQube.

# How to use this image

## Start a SonarQube container

```console
docker run --name sonarqube -d -p 9000:9000 quay.io/ibm/sonarqube:8.5.1.38104
```

## Get Started in Two Minutes Guide

To quickly run a demo instance, see Using Docker on the [Get Started in Two Minutes Guide](https://docs.sonarqube.org/latest/setup/get-started-2-minutes/) page. When you are ready to move to a more sustainable setup, take some time to read the **Configuration** section below.

## Configuration

### Database

By default, the image will use an embedded H2 database that is not suited for production.

> **Warning:** Only a single instance of SonarQube can connect to a database schema. If you're using a Docker Swarm or Kubernetes, make sure that multiple SonarQube instances are never running on the same database schema simultaneously. This will cause SonarQube to behave unpredictably and data will be corrupted. There is no safeguard until [SONAR-10362](https://jira.sonarsource.com/browse/SONAR-10362).

Set up a database by following the "Installing the Database" section of https://docs.sonarqube.org/latest/setup/install-server/.

### Use volumes

We recommend creating volumes for the following directories:

-	`/opt/sonarqube/conf`: **for Version 7.9.x only**, configuration files, such as `sonar.properties`.
-	`/opt/sonarqube/data`: data files, such as the embedded H2 database and Elasticsearch indexes
-	`/opt/sonarqube/logs`: contains SonarQube logs about access, web process, CE process, Elasticsearch logs
-	`/opt/sonarqube/extensions`: plugins, such as language analyzers

> **Warning:** You cannot use the same volumes on multiple instances of SonarQube.

## First Installation

For installation instructions, see Installing the Server from the Docker Image on the [Install the Server](https://docs.sonarqube.org/latest/setup/install-server/) page.

## Upgrading

For upgrade instructions, see Upgrading from the Docker Image on the [Upgrade the Server](https://docs.sonarqube.org/latest/setup/upgrading/) page.

## Advanced configuration

### Customized image

In some environments, it may make more sense to prepare a custom image containing your configuration. A `Dockerfile` to achieve this may be as simple as:

```dockerfile
FROM quay.io/ibm/sonarqube:8.5.1.38104
COPY sonar.properties /opt/sonarqube/conf/
```

You could then build and try the image with something like:

```console
$ docker build --tag=sonarqube-custom .
$ docker run -ti sonarqube-custom
```

### Avoid hard termination of SonarQube

Starting from SonarQube 7.8, SonarQube stops gracefully, waiting for any tasks in progress to finish. Waiting for in-progress tasks to finish can take a large amount of time which the docker does not expect by default when stopping. To avoid having the SonarQube instance killed by the Docker daemon after 10 seconds, it is best to configure a timeout to stop the container with `--stop-timeout`. For example:

```console
docker run --stop-timeout 3600 quay.io/ibm/sonarqube:8.5.1.38104
```

## Administration

The administration guide can be found [here](https://redirect.sonarsource.com/doc/administration-guide.html).

# License

View [license information](http://www.gnu.org/licenses/lgpl.txt) for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

Some additional license information which was able to be auto-detected might be found in [the `repo-info` repository's `sonarqube/` directory](https://github.com/docker-library/repo-info/tree/master/repos/sonarqube).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
