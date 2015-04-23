#!/bin/bash

DEBUG=1
. test/assert.sh

STUBS=test/stubs
PATH="$STUBS:./:$PATH"
DOKKU_ROOT="test/fixtures/dokku"
PLUGIN_PATH="test/dokku/plugins"
REDIS_ROOT="$DOKKU_ROOT/testapp/rediskr"
dokku="PATH=$PATH DOKKU_ROOT=$DOKKU_ROOT PLUGIN_PATH=$PLUGIN_PATH commands"

setup() {
  if [[ ! -d $PLUGIN_PATH ]]; then
    git clone https://github.com/progrium/dokku.git test/dokku
  fi
}

assert_db_exists() {
  assert "[[ -f $REDIS_ROOT/PASS ]] && echo exists" "exists"
  assert "[[ -f $REDIS_ROOT/redis.conf ]] && echo exists" "exists"
  assert "cat $REDIS_ROOT/PORT" "6379"
  assert "cat $REDIS_ROOT/BIND" "6379"
  assert "cat $REDIS_ROOT/CONTAINERID" "testid"
  assert "cat $REDIS_ROOT/IP" "172.17.0.34"
}

cleanup() {
  rm -rf "$REDIS_ROOT"
}

setup

# `redis:create` requires an app name
cleanup
assert "$dokku redis:create 2>&1" "(verify_app_name) APP must not be null"
cleanup
assert_raises "$dokku redis:create" 1

# `redis:create` creates data dir and files
cleanup
assert "$dokku redis:create testapp 2>&1" "-----> Creating database for testapp"
assert_db_exists
cleanup
assert_raises "$dokku redis:create testapp" 0

assert_end examples
cleanup

exit 0
