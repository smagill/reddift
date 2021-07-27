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
  curl -o swift.tar.gz -LO https://swift.org/builds/swift-5.4.2-release/ubuntu2004/swift-5.4.2-RELEASE/swift-5.4.2-RELEASE-ubuntu20.04.tar.gz
  tar xzf swift.tar.gz
  export PATH=/tmp/swift-5.4.2-RELEASE-ubuntu20.04/usr/bin:$PATH
  curl -o swiftlint_linux.zip -LO https://github.com/realm/SwiftLint/releases/download/0.43.1/swiftlint_linux.zip
  unzip -o -qq swiftlint_linux.zip
  popd >/dev/null
}

function emit_results() { 
  echo "$1" | \
        jq '.[] | .file = .file | .line = .line | .type = .rule_id | .message = .reason | del(.severity) | del(.character)' |\
            jq --slurp 'flatten' 
}

function run() {
  gettool
  raw_results=$(/tmp/swiftlint lint --reporter json)
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
