#!/usr/bin/env bash
commit=$2
cmd=$3

function version() {
    echo 1
}

function applicable() {
    echo "true"
}

function gettool() {
  pushd /tmp >/dev/null
  curl -o swiftlint_linux.zip -LO https://github.com/realm/SwiftLint/releases/download/0.43.1/swiftlint_linux.zip
  unzip CodeNarc-2.0.0.zip
  popd >/dev/null
}

function emit_results() { 
  echo "$1" | \
    jq --slurp | \
        jq '.[] | .file = .file | .line = .line | .type = .rule_id | .message = .reason | del(.severity) | del(.character)' | \
            jq --slurp  
  echo "$1"
}

function run() {
  gettool
  raw_results=$(/tmp/swiftlint/swftlint ./)
  emit_results "$raw_results"
}

if [[ "$cmd" = "run" ]] ; then
  run
fi
if [[ "$cmd" = "applicable" ]] ; then
  applicable
fi
if [[ "$cmd" = "version" ]] ; then
  version
fi
