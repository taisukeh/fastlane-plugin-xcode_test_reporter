#!/usr/bin/env bash

tag=0.0.5

set -eu

mkdir -p .temp
cd .temp

curl -s -L -O https://github.com/taisukeh/xcode-test-reporter/releases/download/$tag/xcode-test-reporter_darwin_x86_64.tar.gz
tar xzf xcode-test-reporter_darwin_x86_64.tar.gz

cp xcode-test-reporter ../bin
