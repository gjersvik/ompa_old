#!/bin/bash
set -u
set -e;
echo "Check syntax"
dartanalyzer lib/ompa.dart
dartanalyzer web/ompa.dart
dartanalyzer bin/ompa.dart

echo "Unit Tests Lib"
dart -c test/unittest/lib.dart