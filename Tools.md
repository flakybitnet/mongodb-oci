## Getting tools binaries

MongoDB's tools are downloaded from the Bitnami's container:

```
docker run -it --entrypoint=/bin/bash bitnami/mongodb
```

and packed:

```
tar -cvzf ../tools.tar.gz --owner=0 --group=0 *
```

## Links

1. [MongoDB Tools](https://github.com/mongodb/mongo-tools)
