#!/usr/bin/env bash

export STUBS=test/stubs
export PATH="$STUBS:./:$PATH"
export DOKKU_VERSION=${DOKKU_VERSION:-"v0.3.17"}
export DOKKU_ROOT="test/fixtures/dokku"
export PLUGIN_PATH="test/dokku/plugins"
export REDIS_ROOT="$DOKKU_ROOT/testapp/rediskr"

assert_db_exists() {
  [ -f $REDIS_ROOT/PASS ]
  [ -f $REDIS_ROOT/redis.conf ]
  [ $(cat "$REDIS_ROOT/PORT") = "6379" ]
  [ $(cat "$REDIS_ROOT/BIND") = "6379" ]
  [ $(cat "$REDIS_ROOT/CONTAINERID") = "testid" ]
  [ $(cat "$REDIS_ROOT/IP") = "172.17.0.34" ]
}
