#!/usr/bin/env bash

export STUBS=test/stubs
export PATH="$STUBS:./:$PATH"
export DOKKU_VERSION=${DOKKU_VERSION:-"v0.3.17"}
export DOKKU_ROOT="test/fixtures/dokku"
export PLUGIN_PATH="test/dokku/plugins"
export REDIS_ROOT="$DOKKU_ROOT/testapp/rediskr"

flunk() {
  { if [ "$#" -eq 0 ]; then cat -
    else echo "$*"
    fi
  }
  return 1
}

assert_equal() {
  if [ "$1" != "$2" ]; then
    { echo "expected: $1"
      echo "actual:   $2"
    } | flunk
  fi
}

assert_exists() {
  if [ ! -f "$1" ]; then
    echo "expected file to exist: $1" | flunk
  fi
}

assert_db_exists() {
  assert_exists $REDIS_ROOT/PASS
  assert_exists $REDIS_ROOT/redis.conf
  assert_equal $(cat "$REDIS_ROOT/PORT") "6379"
  assert_equal $(cat "$REDIS_ROOT/BIND") "6379"
  assert_equal $(cat "$REDIS_ROOT/CONTAINERID") "testid"
  assert_equal $(cat "$REDIS_ROOT/IP") "172.17.0.34"
}
