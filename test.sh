#!/bin/bash
set -u
set -e;
dartanalyzer lib/ompa.dart
dartanalyzer web/ompa.dart
dartanalyzer bin/ompa.dart