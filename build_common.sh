#!/bin/bash

read -r -d '' help_text <<- EOM
Usage:
  -b - specify custom branch to clone. Default is 'develop'
  -n - custom namespace on github to clone from. Default is 'NSAPH-Data-Platform'
EOM

branch="develop"
namespace="NSAPH-Data-Platform"

while getopts b:n: flag
do
    case "${flag}" in
        b) branch=${OPTARG};;
        n) namespace=${OPTARG};;
        *) echo "$help_text"; exit;;
    esac
done

rm -rf docs
rm -rf doc/common && mkdir doc/common

package_prefix="nsaph-"
packages=("platform-deployment" "utils" "core-platform" "gis" "epa" "gridmet" "cms" "census")

for name in "${packages[@]}"
do
  package="${package_prefix}${name}"

  git clone --branch $branch https://github.com/$namespace/$package doc/common/$name

  # install library with dependencies
  if [ -a doc/common/$name/setup.py ]
  then
    pip install doc/common/$name
  fi

  # install dependencies if exists
  if [ -a doc/common/$name/requirements.txt ]
  then
    pip install -r doc/common/$name/requirements.txt
  fi

  # make python sources available for autodoc
  abs_path=`realpath doc/common/$name/src/python`
  if [ -n "$abs_path" ]
  then
    export PATH="$abs_path:$PATH"
  fi

done

# build documentation
sphinx-build doc docs
touch docs/.nojekyll

# remove copied repos
rm -rf doc/common
git add docs
