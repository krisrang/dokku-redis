#!/usr/bin/env bash

export STUBS=test/stubs
export PATH="$STUBS:./:$PATH"
export DOKKU_VERSION=${DOKKU_VERSION:-"v0.3.17"}
export DOKKU_ROOT="test/fixtures/dokku"
export PLUGIN_PATH="test/dokku/plugins"
export REDIS_ROOT="$DOKKU_ROOT/testapp/rediskr"
export DOKKU_QUIET_OUTPUT=1

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

assert_exit_status() {
  assert_equal "$status" "$1"
}

assert_success() {
  if [ "$status" -ne 0 ]; then
    flunk "command failed with exit status $status"
  elif [ "$#" -gt 0 ]; then
    assert_output "$1"
  fi
}

assert_exists() {
  if [ ! -f "$1" ]; then
    flunk "expected file to exist: $1"
  fi
}

assert_contains() {
  if [[ "$1" != *"$2"* ]]; then
    flunk "expected $2 to be in: $1"
  fi
}

assert_output() {
  local expected
  if [ $# -eq 0 ]; then expected="$(cat -)"
  else expected="$1"
  fi
  assert_equal "$expected" "$output"
}

assert_db_exists() {
  assert_exists $REDIS_ROOT/PASS
  assert_exists $REDIS_ROOT/redis.conf
  assert_equal "6379" $(cat "$REDIS_ROOT/PORT")
  assert_equal "6379" $(cat "$REDIS_ROOT/BIND")
  assert_equal "testid" $(cat "$REDIS_ROOT/CONTAINERID")
  assert_equal "172.17.0.34" $(cat "$REDIS_ROOT/IP")
}
