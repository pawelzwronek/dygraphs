#!/bin/bash
# This script generates the combined JS file, pushes all content to a web site
# and then reverts the combined file.

if [ "$1" == "" ] ; then
  echo "usage: $0 URL"
  exit 1
fi

set -x
site=$1
# Produce dygraph-combined.js.
./generate-combined.sh

# Generate documentation.
./generate-documentation.py > docs/options.html
./generate-jsdoc.sh

# Copy everything to the site.
scp -r tests jsdoc experimental $site \
&& \
scp dygraph*.js gadget.xml excanvas.js thumbnail.png screenshot.png docs/* $site/

# Revert changes to dygraph-combined.js and docs/options.html
git checkout dygraph-combined.js
rm docs/options.html
