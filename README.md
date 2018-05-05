## Graphite Monitoring Docker Container
*`carbon-c-relay` + `go-carbon` + `whisper` + `graphite-web`*

An `All-In-One` docker container that provides `graphite` monitoring service.

Forked from original python-implementation setup:
https://github.com/nickstenning/docker-graphite


Required packages
=================
  * `Docker`
  * `Make`
  * `docker-compose`

This image contains a sensible default configuration of graphite and
carbon-cache. Starting this container will, by default, bind the the following
host ports:

- `80`: the graphite web interface
- `2003`: the carbon-cache line receiver (the standard graphite protocol)
- `2004`: the carbon-cache pickle receiver
- `7002`: the carbon-cache query port (used by the web interface)

Default Environment Variable Settings by `.env` file
====================================================
| `Variable Name`       |      `Value`        |
|:---------------------:|:-------------------:|
| `DOCKER_NAME`         | `neofob/graphite`   |
| `TAG`                 | `0.1.5`             |
| `CONTAINER_HOSTNAME`  | `graphite-docker`   |
| `CONTAINER_NAME`      | `graphite`          |
| `MEM_LIMIT`           | `16G`               |
|`=====================`|`===================`|
| `GRAPHITE_STORAGE`    | `./graphite_storage`|
| `LOG_DIR`             | `./log`             |
| `CONFIG_DIR`          | `./conf`            |

With this image, you can get up and running with graphite by simply running:
```
  make run
```

You can log into the administrative interface of graphite-web (a Django
application) with the username `admin` and password `admin`. These passwords can
be changed through the web interface.

**N.B.** Please be aware that by default docker will make the exposed ports
accessible from anywhere if the host firewall is unconfigured.

### Data volumes

Graphite data is stored at `/var/lib/graphite/storage/whisper` within the
container. If you wish to store your metrics outside the container (highly
recommended) you can use docker's data volumes feature. For example, to store
graphite's metric database at `/data/graphite` on the host, you could edit `.env`
file
```
GRAPHITE_STORAGE=/path/to/host_graphite_storage
```
Note: `docker-compose` accepts `./` notation instead of the absolute path in
`docker-compose.yml` file.


**N.B.** You will need to run the container with suitable permissions to write
to the data volume directory. Carbon and the graphite webapp run as `www-data`
inside the container, but this UID/GID may be mapped inconsistently on the host.

### Technical details

By default, this `go-carbon` uses the default following retention periods, which
is set by [`conf/graphite/storage-schemas.conf`](./conf/graphite/storage-schemas.conf),
resulting whisper database files about 1.5MB
```
  10s:90d,1m:1y
```

**Author:** *Nick Stenning, Tuan T. Pham*

Design Reference: https://fosdem.org/2017/schedule/event/graphite_at_scale/
