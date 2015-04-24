#!/usr/bin/env bats

load test_helper

teardown() {
  rm -rf "$REDIS_ROOT"
}

@test "redis:create requires an app name" {
  run commands redis:create
  [ "$status" -eq 1 ]
  [ "$output" = "(verify_app_name) APP must not be null" ]
}

@test "redis:create creates data dir and files" {
  run commands redis:create testapp
  assert_db_exists
  [ "$status" -eq 0 ]
  [ "$output" = "-----> Creating database for testapp" ]
}
