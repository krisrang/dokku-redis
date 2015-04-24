#!/usr/bin/env bats

load test_helper

teardown() {
  rm -rf "$REDIS_ROOT"
}

@test "redis:create requires an app name" {
  run commands redis:create
  assert_exit_status 1
  assert_output "(verify_app_name) APP must not be null"
}

@test "redis:create creates data dir and files" {
  run commands redis:create testapp
  assert_db_exists
  assert_success
  assert_output "-----> Creating database for testapp"
}

@test "redis:create with remote bind creates proper bind file" {
  run commands redis:create testapp --bind-port
  assert_success
  assert_output "-----> Creating database for testapp"
  [ "6379" != $(cat "$REDIS_ROOT/BIND" | cut -f 1 -d ":") ]
  [ "6379" = $(cat "$REDIS_ROOT/BIND" | cut -f 2 -d ":") ]
}

@test "redis:delete deletes database" {
  run commands redis:create testapp
  assert_success
  assert_output "-----> Creating database for testapp"
  run commands redis:delete testapp
  assert_success
  assert_output "-----> Deleting database for testapp"
  [ ! -f $REDIS_ROOT ]
}

@test "redis:list lists databases" {
  run commands redis:create testapp
  run commands redis:list --quiet
  assert_success
  assert_contains $output "testapp"
  assert_contains $output "testid"
}

@test "redis:url returns redis url" {
  run commands redis:create testapp
  run commands redis:url testapp
  IP=$(cat "$REDIS_ROOT/IP")
  PASS=$(cat "$REDIS_ROOT/PASS")
  assert_success
  assert_output "redis://redis:$PASS@$IP:6379/0"
}

@test "redis:console calls docker exec" {
  run commands redis:create testapp
  run commands redis:console testapp
  PASS=$(cat "$REDIS_ROOT/PASS")
  assert_success
  assert_output "exec called with exec --interactive --tty testid env TERM=$TERM redis-cli -a $PASS"
}

@test "redis:stop stops redis container" {
  run commands redis:create testapp
  run commands redis:stop testapp
  assert_success
  assert_output "-----> Stopping redis server"
}

@test "redis:dump feeds database dump" {
  run commands redis:create testapp
  echo "databasedump" > "$REDIS_ROOT/data/dump.rdb"
  run commands redis:dump testapp
  assert_success
  assert_output "databasedump"
}

@test "redis:restore writes database dump" {
  run commands redis:create testapp
  echo "databasedump" | run commands redis:restore testapp
  assert_success
  assert_equal "databasedump" $(cat "$REDIS_ROOT/data/dump.rdb")
}

@test "redis:env returns env vars" {
  run commands redis:create testapp
  run commands redis:env testapp
  IP=$(cat "$REDIS_ROOT/IP")
  PASS=$(cat "$REDIS_ROOT/PASS")
  assert_success
  assert_output "-e REDIS_URL=redis://redis:$PASS@$IP:6379/0 -e REDIS_HOST=$IP -e REDIS_PORT=6379 -e REDIS_DB=0 -e REDIS_NAME=0 -e REDIS_PASS=$PASS"
}
