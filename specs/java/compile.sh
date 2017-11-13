#!/usr/bin/env bash
set -e

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

rm -Rf $BASEDIR/smoke/generated
$BASEDIR/generate.sh $1 $BASEDIR/smoke/generated
mvn -e --file $BASEDIR/smoke/generated/pom.xml compile
