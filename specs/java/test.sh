#!/usr/bin/env bash
set -e

BASEDIR=$(dirname "$0")

$BASEDIR/generate.sh $1 $BASEDIR/smoke/generated
mvn -e -DaccessToken=$2 --file $BASEDIR/smoke/pom.xml test
