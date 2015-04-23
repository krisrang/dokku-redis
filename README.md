dokku-redis [![Build Status](https://travis-ci.org/krisrang/dokku-redis.svg?branch=master)](https://travis-ci.org/krisrang/dokku-redis)
================

dokku-redis is a plugin for [dokku][dokku] that provides redis servers for your applications.

It uses the official Redis docker image (version 3.0).

This version is tested against dokku 0.3.17.

## Installation

```
git clone https://github.com/krisrang/dokku-redis /var/lib/dokku/plugins/rediskr
dokku plugins-install
```


## Commands
```
$ dokku help
    redis:console     <app>                          Launch a redis cli for <app>
    redis:create      <app>                          Create a redis database for <app>
    redis:create      <app> --bind-port              Create a redis database for <app> with port binding for remote access
    redis:delete      <app>                          Delete redis database for <app>
    redis:dump        <app> > <filename.rdb>         Dump <app> database to rdb file
    redis:list                                       List all databases
    redis:restart     <app>                          Restart the redis docker container for <app>
    redis:restore     <app> < <filename.rdb>         Restore database to <app> from rdb file
    redis:start       <app>                          Start the redis docker container if it isn't running for <app>
    redis:status      <app>                          Shows status of redis for <app>
    redis:stop        <app>                          Stop the redis docker container for <app>
    redis:url         <app>                          Get REDIS_URL for <app>
```

## Info
This plugin adds the following environment variables to your app via docker args (they are available via `dokku redis:url <app>`):

* REDIS\_URL
* REDIS\_HOST
* REDIS\_NAME
* REDIS\_DB
* REDIS\_PASS
* REDIS\_PORT

## Usage

### Start redis:
```
$ dokku redis:start <app>               # Server side
$ ssh dokku@server redis:start <app>    # Client side
```

### Stop redis:
```
$ dokku redis:stop <app>                # Server side
$ ssh dokku@server redis:stop <app>     # Client side
```

### Restart redis:
```
$ dokku redis:restart <app>             # Server side
$ ssh dokku@server redis:restart <app>  # Client side
```

### Create a new database for an existing app:
```
$ dokku redis:create <app>              # Server side
$ ssh dokku@server redis:create <app>   # Client side
```

### Dump database:
```
$ dokku redis:dump <app> > filename.rdb # Server side
```

### Restore database from dump:
```
$ dokku redis:restore <app> < filename.rdb # Server side
```

### Copy database foo to database bar using pipe:
```
$ dokku redis:dump <app> | dokku redis:restore <app> # Server side
```

## Acknowledgements

This plugin is based originally on the [dokku-psql-single-container](https://github.com/Flink/dokku-psql-single-container).

## License

This plugin is released under the MIT license. See the file [LICENSE](LICENSE).

[dokku]: https://github.com/progrium/dokku
