# niord-wildfly

This project contains scripts to create a specialized Niord Wildfly installation that Niord needs in order to run.
See http://docs.niord.org/dev-guide/guide.html for more details.

# Docker setup

The easiest way to get started is by using docker compose to startup a Wildfly instance and its MySql Database. To do this you simply invoke:

```bash
$ docker-compose up
```

This will create a Docker project called "niord-wildfly" with two containers running:

- niord-wildfly: The actual Wildfly instance
- niord-mysql: A database instance that Wildfly needs in order to run.

This also creates a ~/.niord-db directory on your computer where the Niord applications database is maintained.

# Building Wirefly yourself

You can also build wildfly yourself by standing in this directory and invoking

```bash
$ ./build/build-wildfly.sh
```

This will create a wildfly installation in a folder called wildfly-21.0.0.Final or similar.

You will need to have a local MySql running in order to start it. If you don't have one already you
can use the docker-compose-mysql-only.yml file 

```bash
$ docker-compose -f docker-compose-mysql-only.yml up
```

Finally, you can start the wildfly instance by calling

```bash
$ ./wildfly-21.0.0.Final/bin/standalone.sh
```
# Release Niord Wildfly
In order to release Niord Wildfly as a Docker image you will need access to https://hub.docker.com/u/dmadk

Run the following commands with the actual version replacing the version tag.

```bash
$ docker build . -t dmadk/niord-wildfly:$REPLACE_WITH_VERSION_TAG$
$ docker push dmadk/niord-wildfly:$REPLACE_WITH_VERSION_TAG$
```

You should also update the version in the Helm chart of Niord Proxy (https://github.com/NiordOrg/charts) and release a new chart.
As well as upload a new zip file to https://github.com/NiordOrg/niord-wildfly/releases
