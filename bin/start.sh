#!/bin/bash
set -u -e
echo $1
wget http://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-linux-x64-release.zip
unzip dartsdk-linux-x64-release.zip
./dart-sdk/bin/dart ompa.dart $1