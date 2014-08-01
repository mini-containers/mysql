# mini/mysql

[MySQL](http://dev.mysql.com/) Community Server container.

## Usage

To run this container and bind port `3306`:

```
docker run -d -p 3306:3306 mini/mysql
```

You can now check the logs:

```
docker logs <CONTAINER_ID>
```

### Credentials

Credentials to access the MySQL service are displayed in the container logs
for `admin` user.

`root` level access to this container is limited to local sessions, which is
not available over the TCP interface.

### Setting a custom password

By default this container will generate a random password for `admin` user.
You can specify a fixed one by using `MYSQL_PASS` environment variable:

```
docker run -d -p 3306:3306 -e MYSQL_PASS=mystrongpassword mini/mysql
```

This will only be set the first time the data volume is initialized.

### Data and volumes

This container exposes `/data` as bind mount volume. You can mount it
when starting the container:

```
docker run -v /mydata/mysql:/data -d -p 3306:3306 mini/mysql
```

We recommend you mount the volume to avoid loosing data between updates to this
container.

## License

All the code contained in this repository, unless explicitly stated, is
licensed under ISC license.

A copy of the license can be found inside the [LICENSE](LICENSE) file.
