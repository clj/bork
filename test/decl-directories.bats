#!/usr/bin/env bats

. test/helpers.sh
. declarations/directories.sh

setup () {
  tmpdir=$(mktemp -d -t bork-dir)
  cd $tmpdir
}
teardown () {
  rm -rf $tmpdir
}

mkdirs () {
  for d in $*; do mkdir -p $d; done
}

@test "directories: status returns 0 if all directories are present" {
  mkdirs foo bar
  run bork_decl_directories status foo bar
  [ "$status" -eq 0 ]
}

@test "directories: status returns 10 if no directories are present" {
  run bork_decl_directories status foo bar
  [ "$status" -eq 10 ]
}

@test "directories: status returns 11 if some directories are present" {
  mkdirs bar bee
  run bork_decl_directories status foo bar
  [ "$status" -eq 11 ]
}

@test "directories: status returns 20 if any targets are non-directories" {
  echo "FOO" > foo
  mkdirs bee
  run bork_decl_directories status bee bar foo
  [ "$status" -eq 20 ]
}

@test "directories: install creates all target directories" {
  run bork_decl_directories install foo bar bee
  [ "$status" -eq 0 ]
  run baked_output
  [ "${lines[0]}" = "mkdir -p foo" ]
  [ "${lines[1]}" = "mkdir -p bar" ]
  [ "${lines[2]}" = "mkdir -p bee" ]
}

@test "directories: upgrade creates all missing target directories" {
  mkdirs foo
  run bork_decl_directories upgrade foo bar bee
  [ "$status" -eq 0 ]
  run baked_output
  [ "${lines[0]}" = "mkdir -p bar" ]
  [ "${lines[1]}" = "mkdir -p bee" ]
}
