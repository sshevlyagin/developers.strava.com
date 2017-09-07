#!/bin/bash

mkdir -p $2

for template in swagger/*.json.mustache; do
  destination=$(basename $template | sed 's/\.mustache$//');
  echo "Generating ${2}/${destination} from ${template} (mode=${1})"
  mustache swagger/config/$1.yml $template > $2/$destination
done
